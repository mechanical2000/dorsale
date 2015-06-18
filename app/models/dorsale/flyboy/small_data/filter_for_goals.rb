module Dorsale
  module Flyboy
    module SmallData
      class FilterForGoals < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          'status' => FilterStrategyByStatus.new("goals")
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "goals"
        end
      end
    end
  end
end
