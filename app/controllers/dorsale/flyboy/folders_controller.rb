module Dorsale
  module Flyboy
    class FoldersController < ::Dorsale::Flyboy::ApplicationController
      before_action :set_objects, only: [
        :show,
        :edit,
        :update,
        :destroy,
        :open,
        :close
      ]

      def index
        authorize! :list, Folder

        @folders ||= Folder.all

        @order ||= sortable_column_order do |column, direction|
          case column
          when "name", "status"
            %(LOWER(dorsale_flyboy_folders.#{column}) #{direction})
          when "progress"
            %(dorsale_flyboy_folders.#{column} #{direction})
          else
            params["sort"] = "status"
            "status ASC"
          end
        end

        @filters ||= Dorsale::Flyboy::SmallData::FilterForFolders.new(cookies)

        @folders = @folders.order(@order)
        @folders = @filters.apply(@folders)
        @folders = @folders.search(params[:q])
        @folders = @folders.page(params[:page])
      end

      def show
        authorize! :read, @folder

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

        @tasks = @folder.tasks.order(@order)
      end

      def new
        @folder ||= Folder.new

        authorize! :create, @folder
      end

      def create
        @folder ||= Folder.new(folder_params)

        authorize! :create, @folder

        if @folder.save
          flash[:success] = t("messages.folders.create_ok")
          redirect_to @folder
        else
          render :new
        end
      end

      def edit
        authorize! :update, @folder
      end

      def update
        authorize! :update, @folder

        if @folder.update_attributes(folder_params)
          flash[:success] = t("messages.folders.update_ok")

          if @folder.closed?
            redirect_to dorsale.flyboy_folders_path
          else
            redirect_to @folder
          end
        else
          render :edit
        end
      end

      def destroy
        authorize! :delete, @folder

        @folder.destroy
        redirect_to dorsale.flyboy_folders_path
      end

      def open
        if @folder.open!
          flash[:success] = t("messages.folders.open_ok")
        else
          flash[:danger] = t("messages.folders.open_error")
        end

        redirect_to @folder
      end

      def close
        if @folder.close!
          flash[:success] = t("messages.folders.close_ok")
        else
          flash[:danger] = t("messages.folders.close_error")
        end

        redirect_to dorsale.flyboy_folders_path
      end

      private

      def set_objects
        @folder = Folder.find(params[:id])
      end

      def permitted_params
        [:name, :description]
      end

      def folder_params
        params.require(:folder).permit(permitted_params)
      end

    end
  end
end
