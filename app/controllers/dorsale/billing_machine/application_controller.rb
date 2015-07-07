module Dorsale
  module BillingMachine
    class ApplicationController < ::ApplicationController
      before_filter :set_common_variables

      private

      def set_common_variables
        @payment_terms ||= ::Dorsale::BillingMachine::PaymentTerm.all
        @id_cards      ||= ::Dorsale::BillingMachine::IdCard.all
        @people        ||= ::Dorsale::CustomerVault::Person.list
      end
    end
  end
end
