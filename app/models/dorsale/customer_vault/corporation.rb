class Dorsale::CustomerVault::Corporation < ActiveRecord::Base
  self.table_name = "dorsale_customer_vault_corporations"
  include ::Dorsale::CustomerVault::Person
  include ::Dorsale::Search

  validates :name, presence: true
end
