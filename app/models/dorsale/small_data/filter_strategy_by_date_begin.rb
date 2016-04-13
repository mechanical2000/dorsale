module Dorsale
  module SmallData
    class FilterStrategyByDateBegin < ::Dorsale::SmallData::FilterStrategyByKeyValue
      def apply(query, value)
        value = Time.parse(value).beginning_of_day
        query.where("#{key} >= ?", value)
      end
    end # FilterStrategy
  end # SmallData
end # Dorsale
