module Dorsale
  module BillingMachine
    class IdCard < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_id_cards"

      has_many :invoices
      has_many :quotations

      validates :id_card_name, presence: true

      def name
        id_card_name
      end
    end
  end
end
