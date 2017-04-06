class Dorsale::Comment < ::Dorsale::ApplicationRecord
  belongs_to :author, polymorphic: true
  belongs_to :commentable, polymorphic: true

  validates :author,      presence: true
  validates :commentable, presence: true
  validates :text,        presence: true
  validates :date,        presence: true

  default_scope -> {
    all
      .order(date: :desc, created_at: :desc)
      .preload(:author)
  }

  private

  def assign_default_values
    assign_default :date, Time.zone.now.to_date
  end
end
