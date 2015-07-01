module Dorsale
  module Flyboy
    module SmallData
      class FilterForFolders < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          'status' => FilterStrategyByStatus.new("folders")
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "folders"
        end
      end
    end
  end
end
