module Dorsale
  module SmallData
    class FilterStrategy
      def apply(query, value)
        raise NotImplementedError
      end
    end # FilterStrategy
  end # SmallData
end # Dorsale
