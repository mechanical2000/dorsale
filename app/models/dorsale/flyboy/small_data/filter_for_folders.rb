module Dorsale
  module Flyboy
    module SmallData
      class FilterForFolders < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "fb_status" => FilterStrategyByStatus.new,
        }
      end
    end
  end
end
