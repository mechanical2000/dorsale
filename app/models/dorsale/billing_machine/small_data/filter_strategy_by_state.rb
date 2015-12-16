module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByState < ::Dorsale::SmallData::FilterStrategy
        def do_apply(query)
          if @value.to_s.match(/not_(.+)/)
            query.where("state != ?", $~[1])
          else
            query.where(state: @value)
          end
        end
      end
    end
  end
end
