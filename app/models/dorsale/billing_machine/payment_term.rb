module Dorsale
  module BillingMachine
    class PaymentTerm < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_payment_terms"

      def name
        label
      end

    end
  end
end
