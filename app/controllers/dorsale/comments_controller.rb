module Dorsale
  class CommentsController < ApplicationController
    def create
      @comment = Comment.new(comment_params)
      @comment.author = try(:current_user)

      authorize! :create, @comment

      if @comment.save
        flash[:success] = t("messages.comments.create_ok")
      else
        flash[:danger] = t("messages.comments.create_error")
      end

      redirect_to_back_url
    end

    def edit
      @comment = ::Dorsale::Comment.find params[:id]

      authorize! :update, @comment

      render layout: false
    end

    def update
      @comment = ::Dorsale::Comment.find params[:id]

      authorize! :update, @comment

      if @comment.update_attributes(comment_params)
        flash[:notice] = t("messages.comments.update_ok")
      else
        flash[:alert] = t("messages.comments.update_error")
      end

      redirect_to_back_url
    end

    def destroy
      @comment = ::Dorsale::Comment.find params[:id]

      authorize! :delete, @comment

      if @comment.destroy
        flash[:notice] = t("messages.comments.delete_ok")
      else
        flash[:alert] = t("messages.comments.delete_error")
      end

      redirect_to_back_url
    end

    private

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
      params.require(:comment).permit(permitted_params_for_comment)
    end

    def redirect_to_back_url
      redirect_to params[:back_url] || request.referer
    end
  end
end
