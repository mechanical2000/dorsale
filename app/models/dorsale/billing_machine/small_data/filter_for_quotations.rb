module Dorsale
  module BillingMachine
    module SmallData
      class FilterForQuotations < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "customer_guid"      => FilterStrategyByCustomer.new("quotations"),
          "bm_time_period"     => FilterStrategyByTimePeriod.new("quotations"),
          "bm_quotation_state" => FilterStrategyByState.new("quotations"),
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "quotations"
        end

        def customer_guid
          get(__method__)
        end

        def bm_time_period
          get(__method__)
        end

        def bm_quotation_state
          get(__method__)
        end

      end
    end
  end
end
