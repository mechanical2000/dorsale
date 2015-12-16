module Dorsale
  module Flyboy
    module SmallData
      class FilterForTasks < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "fb_status" => FilterStrategyByDone.new("tasks"),
          "owner"     => FilterStrategyByOwner.new("tasks")
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "tasks"
        end
      end
    end
  end
end
