module Dorsale
  module CustomerVault
    class Corporation < Person
      self.table_name = "dorsale_customer_vault_corporations"

      include ::Dorsale::Search

      validates :name, presence: true

    end
  end
end
