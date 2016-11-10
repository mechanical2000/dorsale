class Dorsale::Comment < ::Dorsale::ApplicationRecord
  belongs_to :author, polymorphic: true
  belongs_to :commentable, polymorphic: true

  validates :author,      presence: true
  validates :commentable, presence: true
  validates :text,        presence: true

  default_scope -> {
    all
      .order(created_at: :desc)
      .preload(:author)
  }
end
