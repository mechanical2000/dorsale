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
          get("customer_guid")
        end

        def bm_time_period
          get("time_period")
        end

        def bm_quotation_state
          get("quotation_state")
        end

      end
    end
  end
end
