module Dorsale
  module SmallData
    class FilterStrategyByDate < ::Dorsale::SmallData::FilterStrategyByKeyValue
      def apply(query, value)
        value = Date.parse(value)
        super(query, value)
      end
    end # FilterStrategy
  end # SmallData
end # Dorsale
