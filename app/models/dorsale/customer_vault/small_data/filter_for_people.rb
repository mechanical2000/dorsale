module Dorsale
  module CustomerVault
    module SmallData
      class FilterForPeople < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "tags" => ::Dorsale::CustomerVault::SmallData::FilterStrategyByTags.new("people")
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "people"
        end
      end
    end
  end
end
