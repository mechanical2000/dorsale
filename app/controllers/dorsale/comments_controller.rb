class Dorsale::CommentsController < ::Dorsale::ApplicationController
  def create
    @comment = model.new(comment_params)
    @comment.author = try(:current_user)

    authorize @comment, :create?

    if @comment.save
      flash[:success] = t("messages.comments.create_ok")
    else
      flash[:danger] = t("messages.comments.create_error")
    end

    redirect_to back_url
  end

  def edit
    @comment = model.find params[:id]

    authorize @comment, :update?

    render layout: false
  end

  def update
    @comment = model.find params[:id]

    authorize @comment, :update?

    if @comment.update_attributes(comment_params)
      flash[:notice] = t("messages.comments.update_ok")
    else
      flash[:alert] = t("messages.comments.update_error")
    end

    redirect_to back_url
  end

  def destroy
    @comment = model.find params[:id]

    authorize @comment, :delete?

    if @comment.destroy
      flash[:notice] = t("messages.comments.delete_ok")
    else
      flash[:alert] = t("messages.comments.delete_error")
    end

    redirect_to back_url
  end

  private

  def model
    ::Dorsale::Comment
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

end
