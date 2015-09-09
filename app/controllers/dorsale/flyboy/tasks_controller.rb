module Dorsale
  module Flyboy
    class TasksController < ::Dorsale::Flyboy::ApplicationController
      before_action :set_objects, only: [
        :show,
        :edit,
        :update,
        :destroy,
        :complete,
        :snooze
      ]

      def index
        authorize! :list, Task

        @tasks ||= current_user.tasks

        @order ||= sortable_column_order do |column, direction|
          case column
          when "name", "status"
            %(LOWER(dorsale_flyboy_tasks.#{column}) #{direction})
          when "progress", "term"
            %(dorsale_flyboy_tasks.#{column} #{direction})
          when "taskable"
            if direction == :asc
              proc { |a, b| a.taskable.name.downcase <=> b.taskable.name.downcase }
            else
              proc { |a, b| b.taskable.name.downcase <=> a.taskable.name.downcase }
            end
          else
            params["sort"] = "term"
            "term ASC"
          end
        end

        @filters ||= ::Dorsale::Flyboy::SmallData::FilterForTasks.new(cookies)

        @tasks = @filters.apply(@tasks)
        @tasks = @tasks.search(params[:q])

        if @order.is_a?(Proc) # when sorting by a polymorphic attribute
          @tasks = @tasks.sort(&@order)
          @tasks_without_pagination = @tasks
          @tasks = Kaminari.paginate_array(@tasks).page(params[:page])
        else
          @tasks = @tasks.order(@order)
          @tasks_without_pagination = @tasks
          @tasks = @tasks.page(params[:page])
        end

        respond_to do |format|
          format.html

          format.csv do
            send_data @tasks_without_pagination.to_csv,
              filename:    "feuille_de_route_#{Date.today}.csv",
              disposition: "attachment"
          end

          format.xls

          format.pdf do
            pdf = Roadmap.new(@tasks_without_pagination)
            pdf.build
            send_data pdf.render,
              filename:    "feuille_de_route_#{Date.today}.pdf",
              disposition: "inline"
          end
        end

      end

      def show
        @task = Task.find(params[:id])

        authorize! :read, @task
      end

      def new
        @task = Task.new
        @task.taskable_guid = params[:taskable_guid]
        @owners ||= current_user.colleagues(@task.taskable)

        authorize! :create, @task
      end

      def edit
        authorize! :update, @task
        @owners ||= current_user.colleagues(@task.taskable)
      end

      def create
        @task ||= Task.new(task_params)

        authorize! :create, @task

        if @task.save
          flash[:success] = t("messages.tasks.create_ok")
          redirect_to @task
        else
          render :new
        end
      end

      def update
        authorize! :update, @task

        if @task.update_attributes(task_params)
          flash[:success] = t("messages.tasks.update_ok")
          redirect_to @task
        else
          render :edit
        end
      end

      def destroy
        authorize! :delete, @task

        if @task.destroy
          flash[:success] = t("messages.tasks.delete_ok")
        else
          flash[:danger] = t("messages.tasks.delete_error")
        end

        redirect_to dorsale.flyboy_tasks_path
      end

      def complete
        authorize! :complete, @task

        @task_comment ||= @task.comments.new(
          :progress    => 100,
          :description => t("messages.tasks.complete_ok"),
          :date        => DateTime.now,
          :author      => current_user
        )

        if @task_comment.save
          flash[:success] = t("messages.tasks.complete_ok")
        else
          flash[:danger] = t("messages.tasks.complete_error")
        end

        redirect_to request.referer
      end

      def snooze
        @task.snooze

        if @task.save
          flash[:success] = t("messages.tasks.snooze_ok")
        else
          flash[:danger] = t("messages.tasks.snooze_error")
        end

        redirect_to dorsale.flyboy_tasks_path
      end

      private

      def set_objects
        @task = Task.find params[:id]
        @taskable = @task.taskable
      end

      def permitted_params
        [:taskable_id, :taskable_type, :name, :description, :progress, :term, :reminder, :owner_guid]
      end

      def task_params
        params.require(:task).permit(permitted_params)
      end

    end
  end
end
