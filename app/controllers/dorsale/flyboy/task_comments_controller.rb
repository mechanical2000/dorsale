module Dorsale
  module Flyboy
    class TaskCommentsController < ::Dorsale::Flyboy::ApplicationController
      def create
        @task_comment ||= TaskComment.new(task_comment_params)
        @task = @task_comment.task

        authorize! :update, @task

        if @task_comment.save
          redirect_to @task
        else
          render "dorsale/flyboy/tasks/show"
        end
      end

      private

      def permitted_params
        [:task_id, :progress, :description]
      end

      def task_comment_params
        params.require(:task_comment).permit(permitted_params)
      end

    end
  end
end
