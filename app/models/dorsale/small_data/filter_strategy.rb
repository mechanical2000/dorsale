module Dorsale
  module SmallData
    class FilterStrategy
      def initialize(target)
        @target = target
      end

      def set(key, value)
        @key   = key
        @value = value
        return self
      end

      def apply(query)
        if @value and @value != ''
          do_apply(query)
        else
          query
        end
      end

      def applies?(target)
        @target == target
      end
    end
  end
end
