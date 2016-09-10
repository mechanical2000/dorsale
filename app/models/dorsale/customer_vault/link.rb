class Dorsale::CustomerVault::Link < ActiveRecord::Base
  self.table_name = "dorsale_customer_vault_links"

  belongs_to :alice, polymorphic: true
  belongs_to :bob,   polymorphic: true
end
