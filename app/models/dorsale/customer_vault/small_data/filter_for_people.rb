module Dorsale
  module CustomerVault
    module SmallData
      class FilterForPeople < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "tags" => ::Dorsale::CustomerVault::SmallData::FilterStrategyByTags.new
        }
      end
    end
  end
end
