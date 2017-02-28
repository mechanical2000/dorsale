class Dorsale::BillingMachine::SmallData::FilterForQuotations < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "bm_time_period"     => ::Agilibox::SmallData::FilterStrategyByTimePeriod.new(:date),
    "bm_date_begin"      => ::Agilibox::SmallData::FilterStrategyByDateBegin.new(:date),
    "bm_date_end"        => ::Agilibox::SmallData::FilterStrategyByDateEnd.new(:date),
    "bm_customer_guid"   => ::Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer.new,
    "bm_quotation_state" => ::Dorsale::BillingMachine::SmallData::FilterStrategyByState.new,
  }
end
