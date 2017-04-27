class Dorsale::CustomerVault::Origin < ::Dorsale::ApplicationRecord
  self.table_name = "dorsale_customer_vault_origins"

  validates :name, presence: true

  def to_s
    name
  end
end
