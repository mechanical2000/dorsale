module Dorsale
  module CustomerVault
    module SmallData
      class FilterStrategyByTags < ::Dorsale::SmallData::FilterStrategy
        def do_apply(query)
          @value = [*@value].flatten.select{ |v| v.present? }

          if @value.any?
            query.tagged_with(@value)
          else
            query
          end

        end
      end
    end
  end
end
