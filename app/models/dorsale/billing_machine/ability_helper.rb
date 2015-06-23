module Dorsale
  module BillingMachine
    module AbilityHelper
      def define_dorsale_billing_machine_abilities
        can [:list, :create, :read, :update, :pay, :copy], ::Dorsale::BillingMachine::Invoice
        can [:list, :create, :read, :update, :delete],     ::Dorsale::BillingMachine::Quotation
      end
    end
  end
end
