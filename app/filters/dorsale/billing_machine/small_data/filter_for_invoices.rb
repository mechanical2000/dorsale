class Dorsale::BillingMachine::SmallData::FilterForInvoices < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "customer_guid"     => ::Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer.new,
    "bm_time_period"    => ::Dorsale::SmallData::FilterStrategyByTimePeriod.new(:date),
    "bm_date_begin"     => ::Dorsale::SmallData::FilterStrategyByDateBegin.new(:date),
    "bm_date_end"       => ::Dorsale::SmallData::FilterStrategyByDateEnd.new(:date),
    "bm_payment_status" => ::Dorsale::BillingMachine::SmallData::FilterStrategyByPaymentStatus.new,
  }
end
