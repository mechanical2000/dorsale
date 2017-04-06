module Dorsale::CommentsHelper
  def comments_for(commentable, options = {})
    comments = policy_scope(::Dorsale::Comment)
      .where(commentable: commentable)
      .preload(:commentable, :author)

    new_comment = comments.new(author: current_user)

    render(
      :partial => "dorsale/comments/comments",
      :locals  => {
        :comments    => comments,
        :new_comment => new_comment,
      },
    )
  end

  def truncate_comment_text?
    controller_name == "people" && action_name == "activity"
  end
end
