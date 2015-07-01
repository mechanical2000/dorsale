module Dorsale
  module Flyboy
    module SmallData
      class FilterStrategyByDone < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          value = (@value == 'closed')
          query.where(done: value)
        end
      end
    end
  end
end
