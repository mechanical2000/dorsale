module Dorsale
  module Flyboy
    module SmallData
      class FilterForTasks < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "fb_status" => FilterStrategyByDone.new,
          "owner"     => ::Dorsale::SmallData::FilterStrategyByKeyValue.new("owner_id")
        }
      end
    end
  end
end
