module Dorsale
  module Flyboy
    module SmallData
      class FilterStrategyByOwner < Dorsale::SmallData::FilterStrategy
        def do_apply(query)
          query.where(owner_id: @value)
        end
      end
    end
  end
end
