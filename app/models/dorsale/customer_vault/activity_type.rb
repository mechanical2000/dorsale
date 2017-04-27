class Dorsale::CustomerVault::ActivityType < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_customer_vault_activity_types"

  validates :name, presence: true

  def to_s
    name
  end
end
