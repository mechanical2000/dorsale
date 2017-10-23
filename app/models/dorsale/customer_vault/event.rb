class Dorsale::CustomerVault::Event < ::Dorsale::ApplicationRecord
  self.table_name = :dorsale_customer_vault_events

  ACTIONS = %w(create update comment)

  belongs_to :author,  class_name: User
  belongs_to :person,  class_name: Dorsale::CustomerVault::Person

  validates :person,  presence: true
  validates :date,    presence: true
  validates :text,    presence: true
  validates :action,  presence: true, inclusion: {in: proc {ACTIONS} }

  default_scope -> {
    all
      .order(created_at: :desc, id: :desc)
      .preload(:author, :person)
  }

  private

  def assign_default_values
    assign_default :date, Date.current
  end
end
