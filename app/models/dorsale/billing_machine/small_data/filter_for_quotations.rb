module Dorsale
  module BillingMachine
    module SmallData
      class FilterForQuotations < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "customer_guid"      => FilterStrategyByCustomer.new,
          "bm_time_period"     => FilterStrategyByTimePeriod.new(:date),
          "bm_quotation_state" => FilterStrategyByState.new,
        }
      end
    end
  end
end
