class Dorsale::Flyboy::TaskCommentsController < ::Dorsale::Flyboy::ApplicationController
  def create
    @task_comment ||= model.new(task_comment_params)
    @task_comment.author = current_user

    @task = @task_comment.task

    authorize! :update, @task

    if @task_comment.save
      redirect_to @task
    else
      render "dorsale/flyboy/tasks/show"
    end
  end

  private

  def model
    ::Dorsale::Flyboy::TaskComment
  end

  def permitted_params
    [
      :task_id,
      :progress,
      :description,
    ]
  end

  def task_comment_params
    params.fetch(:task_comment, {}).permit(permitted_params)
  end

end
