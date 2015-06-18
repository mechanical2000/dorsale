module Dorsale
  module Flyboy
    class GoalsController < ::Dorsale::Flyboy::ApplicationController
      handles_sortable_columns

      before_action :set_objects, only: [
        :show,
        :edit,
        :update,
        :destroy,
        :open,
        :close
      ]

      def index
        authorize! :list, Goal

        @goals ||= Goal.all

        @order ||= sortable_column_order do |column, direction|
          case column
          when "name", "status"
            %(LOWER(dorsale_flyboy_goals.#{column}) #{direction})
          when "progress"
            %(dorsale_flyboy_goals.#{column} #{direction})
          else
            params["sort"] = "status"
            "status ASC"
          end
        end

        @filters ||= Dorsale::Flyboy::SmallData::FilterForGoals.new(cookies)

        @goals = @goals.order(@order)
        @goals = @filters.apply(@goals)
        @goals = @goals.search(params[:q])
        @goals = @goals.page(params[:page])
      end

      def show
        authorize! :read, @goal

        @order ||= sortable_column_order do |column, direction|
          case column
          when "name", "status"
            %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
          when "progress", "term"
            %(dorsale_flyboy_tasks.#{column} #{direction})
          else
            params["sort"] = "term"
            "term ASC"
          end
        end

        @tasks = @goal.tasks.order(@order)
      end

      def new
        @goal ||= Goal.new

        authorize! :create, @goal
      end

      def create
        @goal ||= Goal.new(goal_params)

        authorize! :create, @goal

        if @goal.save
          flash[:success] = t("messages.goals.create_ok")
          redirect_to @goal
        else
          render :new
        end
      end

      def edit
        authorize! :update, @goal
      end

      def update
        authorize! :update, @goal

        if @goal.update_attributes(goal_params)
          flash[:success] = t("messages.goals.update_ok")

          if @goal.closed?
            redirect_to dorsale.flyboy_goals_path
          else
            redirect_to @goal
          end
        else
          render :edit
        end
      end

      def destroy
        authorize! :delete, @goal

        @goal.destroy
        redirect_to dorsale.flyboy_goals_path
      end

      def open
        if @goal.open!
          flash[:success] = t("messages.goals.open_ok")
        else
          flash[:danger] = t("messages.goals.open_error")
        end

        redirect_to @goal
      end

      def close
        if @goal.close!
          flash[:success] = t("messages.goals.close_ok")
        else
          flash[:danger] = t("messages.goals.close_error")
        end

        redirect_to dorsale.flyboy_goals_path
      end

      private

      def set_objects
        @goal = Goal.find(params[:id])
      end

      def permitted_params
        [:name, :description]
      end

      def goal_params
        params.require(:goal).permit(permitted_params)
      end

    end
  end
end
