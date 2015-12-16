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

      def billing_machine_quotation_states_for_filter_select
        billing_machine_quotation_states_for_select.unshift \
          [::Dorsale::BillingMachine::Quotation.t("state.all"), ""]
      end

      def billing_machine_payment_status_for_filter_select
        {
          ::Dorsale::BillingMachine::Invoice.t("payment_status.all")     => "",
          ::Dorsale::BillingMachine::Invoice.t("payment_status.unpaid")  => "unpaid",
          ::Dorsale::BillingMachine::Invoice.t("payment_status.pending") => "pending",
          ::Dorsale::BillingMachine::Invoice.t("payment_status.late")    => "late",
          ::Dorsale::BillingMachine::Invoice.t("payment_status.paid")    => "paid",
        }
      end

    end
  end
end
