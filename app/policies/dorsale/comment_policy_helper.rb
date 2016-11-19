module Dorsale::CommentPolicyHelper
  POLICY_METHODS = [
    :create?,
    :update?,
    :delete?,
  ]

  def create?
    return false unless can_read_commentable?
    super
  end

  def update?
    return false unless can_read_commentable?
    super
  end

  def delete?
    return false unless can_read_commentable?
    super
  end

  private

  def can_read_commentable?
    policy(comment.commentable).read?
  end
end
