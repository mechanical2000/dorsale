class Dorsale::BillingMachine::SmallData::FilterForInvoices < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "bm_time_period"    => ::Agilibox::SmallData::FilterStrategyByDatePeriod.new(:date),
    "bm_date_begin"     => ::Agilibox::SmallData::FilterStrategyByDateBegin.new(:date),
    "bm_date_end"       => ::Agilibox::SmallData::FilterStrategyByDateEnd.new(:date),
    "bm_customer_guid"  => ::Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer.new,
    "bm_payment_status" => ::Dorsale::BillingMachine::SmallData::FilterStrategyByPaymentStatus.new,
  }
end
