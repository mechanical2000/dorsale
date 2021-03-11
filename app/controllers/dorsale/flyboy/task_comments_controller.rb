class Dorsale::Flyboy::TaskCommentsController < ::Dorsale::Flyboy::ApplicationController
  def create
    skip_policy_scope

    @task_comment ||= model.new(task_comment_params_for_create)
    @task         ||= @task_comment.task

    authorize @task, :comment?

    if @task_comment.save
      redirect_to back_url
    else
      @task_comments = @task.comments
      render "dorsale/flyboy/tasks/show"
    end
  end

  private

  def back_url
    task_path = flyboy_task_path(@task)
    back_url  = super.to_s

    if back_url == task_path || back_url.start_with?(task_path + "?")
      back_url
    else
      task_path
    end
  end

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

  def task_comment_params_for_create
    task_comment_params.merge(author: current_user)
  end
end
