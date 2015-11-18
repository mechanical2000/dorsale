module Dorsale
  module BillingMachine
    self.vat_mode = :multiple
    class ApplicationController < ::Dorsale::ApplicationController
      before_filter :set_common_variables

      private

      def set_common_variables
        @payment_terms ||= ::Dorsale::BillingMachine::PaymentTerm.all
        @id_cards      ||= ::Dorsale::BillingMachine::IdCard.all
        @people        ||= current_user_scope.people
      end
    end
  end
end
