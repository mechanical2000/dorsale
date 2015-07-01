module Dorsale
  module Flyboy
    module SmallData
      class FilterStrategyByNothing < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          return query
        end
      end
    end
  end
end
