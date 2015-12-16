module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByState < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          query.where(state: @value)
        end
      end
    end
  end
end
