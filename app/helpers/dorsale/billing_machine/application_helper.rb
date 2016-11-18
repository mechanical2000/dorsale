module Dorsale::BillingMachine::ApplicationHelper
  def billing_machine_quotation_states_for_select
    ::Dorsale::BillingMachine::Quotation::STATES.map do |e|
      [
        ::Dorsale::BillingMachine::Quotation.t("state.#{e}"),
        e,
      ]
    end
  end

  def billing_machine_quotation_states_for_filter_select
      [
        [::Dorsale::BillingMachine::Quotation.t("state.all"), ""],
        [::Dorsale::BillingMachine::Quotation.t("state.not_canceled"), "not_canceled"],
      ] + billing_machine_quotation_states_for_select
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

  def quotation_state_classes(quotation)
    if quotation.state == "pending" && quotation.date < 1.month.ago
      return "pending late"
    else
      return quotation.state
    end
  end

  def billing_machine_invoices_chart
    invoices = policy_scope(::Dorsale::BillingMachine::Invoice)
      .where("date > ?", 1.year.ago.beginning_of_month)

    totals = {}

    (0..12).to_a.reverse.map do |n|
      date  = n.month.ago
      label = l(date, format: "%B %Y").titleize
      totals[label] = 0
      invoices.each do |i|
        next if i.date.year  != date.year
        next if i.date.month != date.month
        totals[label] += i.total_excluding_taxes
      end
    end

    column_chart totals, height: "200px"
  end

  def bm_currency(n)
    currency(n, ::Dorsale::BillingMachine.default_currency)
  end
end
