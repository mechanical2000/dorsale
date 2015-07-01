module Dorsale
  module BillingMachine
    module SmallData
      class FilterForQuotations < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          'customer_guid' => FilterStrategyByCustomer.new('quotations'),
          'time_period'   => FilterStrategyByTimePeriod.new('quotations'),
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          'quotations'
        end
      end
    end
  end
end
