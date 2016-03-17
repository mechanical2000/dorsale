module Dorsale
  module Flyboy
    module SmallData
      class FilterStrategyByDone < ::Dorsale::SmallData::FilterStrategy
        def apply(query, value)
          value = (value == "closed")
          query.where(done: value)
        end
      end
    end
  end
end
