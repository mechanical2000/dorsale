module Dorsale
  module BillingMachine
    class ApplicationController < ::Dorsale::ApplicationController
      before_filter :set_common_variables

      private

      def euros(*)
        raise "#euros is not available in BillingMachine, please use #bm_currency instead"
      end

      def bm_currency(n)
        DH.currency(n, BillingMachine.default_currency)
      end

      helper_method :euros
      helper_method :bm_currency

      def set_common_variables
        @payment_terms ||= ::Dorsale::BillingMachine::PaymentTerm.all
        @id_cards      ||= ::Dorsale::BillingMachine::IdCard.all
        @people        ||= current_user_scope.people
      end

    end
  end
end
