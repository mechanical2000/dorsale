class Dorsale::CustomerVault::Event < ::Dorsale::ApplicationRecord
  self.table_name = :dorsale_customer_vault_events

  ACTIONS = %w(create update comment)

  belongs_to :author,  class_name: User
  belongs_to :person,  class_name: Dorsale::CustomerVault::Person
  belongs_to :comment, class_name: Dorsale::Comment

  validates :person,  presence: true
  validates :action,  presence: true, inclusion: {in: proc {ACTIONS} }
  validates :comment, presence: true, if: proc { action == "comment" }

  default_scope -> {
    all
      .order(created_at: :desc, id: :desc)
      .preload(:author, :person, :comment)
  }

  def date
    created_at.try(:to_date)
  end
end
