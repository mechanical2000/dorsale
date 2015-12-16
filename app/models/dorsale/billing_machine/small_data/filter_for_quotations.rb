module Dorsale
  module BillingMachine
    module SmallData
      class FilterForQuotations < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "customer_guid"   => FilterStrategyByCustomer.new("quotations"),
          "time_period"     => FilterStrategyByTimePeriod.new("quotations"),
          "quotation_state" => FilterStrategyByState.new("quotations"),
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

        def time_period
          get("time_period")
        end

        def quotation_state
          get("quotation_state")
        end

      end
    end
  end
end
