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

  def truncate_comments_in_this_page?
    controller_name == "people"
  end

  def truncate_comment_text(comment)
    text      = comment.text.to_s
    truncated = false

    if text.to_s.count("\n") > 3
      text      = text.split("\n")[0, 3].join("\n")
      truncated = true
    end

    if text.to_s.length > 300
      text      = truncate(text, length: 200)
      truncated = true
    end

    text2html(text) if truncated
  end
end
