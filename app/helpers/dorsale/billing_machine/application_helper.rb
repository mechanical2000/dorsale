module Dorsale
  module BillingMachine
    module ApplicationHelper
      def billing_machine_quotation_states_for_select
        ::Dorsale::BillingMachine::Quotation::STATES.map do |e|
          [
            ::Dorsale::BillingMachine::Quotation.t("state.#{e}"),
            e,
          ]
        end
      end
    end
  end
end
