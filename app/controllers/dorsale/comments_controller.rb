class Dorsale::CommentsController < ::Dorsale::ApplicationController
  before_action :set_objects, only: [
    :edit,
    :update,
    :destroy,
  ]

  layout false

  def create
    @comment ||= scope.new(comment_params_for_create)

    authorize @comment, :create?

    if @comment.save
      render_comment
    else
      render_nothing
    end
  end

  def edit
    authorize @comment, :update?
  end

  def update
    authorize @comment, :update?

    if @comment.update(comment_params_for_update)
      render_comment
    else
      render_form
    end
  end

  def destroy
    authorize @comment, :delete?

    @comment.destroy

    render_nothing
  end

  private

  def render_comment
    if request.xhr?
      render partial: "comment", locals: {comment: @comment}
    else
      redirect_to back_url
    end
  end

  def render_form
    if request.xhr?
      render partial: "form", locals: {comment: @comment}
    else
      redirect_to back_url
    end
  end

  def render_nothing
    if request.xhr?
      head :ok
    else
      redirect_to back_url
    end
  end

  def back_url
    [
      params[:form_url],
      request.referer,
      (main_app.root_path rescue "/"),
    ].select(&:present?).first
  end

  def model
    ::Dorsale::Comment
  end

  def set_objects
    @comment ||= scope.find(params[:id])
  end

  def permitted_params_for_comment
    if params[:action] == "create"
      [
        :commentable_id,
        :commentable_type,
        :text,
      ]
    else
      [
        :text,
      ]
    end
  end

  def comment_params
    params.fetch(:comment, {}).permit(permitted_params_for_comment)
  end

  def comment_params_for_create
    comment_params.merge(author: current_user)
  end

  def comment_params_for_update
    comment_params
  end
end
