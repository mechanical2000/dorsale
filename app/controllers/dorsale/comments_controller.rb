# encoding: utf-8

module Dorsale
  class CommentsController < ApplicationController
    def create
      if defined?(current_user) && current_user.present?
        @comment = current_user.comments.new(comment_params)
      else
        @comment = Comment.new(comment_params)
      end
      
      if @comment.save
        flash[:success] = "Comment was successfully created."
      else
        flash[:danger] = "Error : comment not saved."
      end
      
      redirect_to params[:back_url] || request.referer || main_app.root_path
    end
    
    private
    
    def permitted_params
      [:commentable_id, :commentable_type, :text]
    end
    
    def comment_params
      params.require(:comment).permit(permitted_params)
    end
  end
end
