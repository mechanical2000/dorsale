module Dorsale
  module SmallData
    class Filter

      def initialize(jar)
        @jar = jar
      end

      def store(filters)
        @jar['filters'] = filters.to_json
      end

      def read
        if @jar['filters']
          begin
            JSON.parse @jar['filters']
          rescue JSON::ParserError
            {}
          end
        else
          {}
        end
      end

      def get(key)
        read[key.to_s]
      end

      def set(key, value)
        array           = read
        array[key.to_s] = value
        store(array)
      end

      def apply(query)
        read.each do |key, value|
          filter = strategy(key)

          if filter && filter.applies?(self.target)
            filter.set(key, value)
            query = filter.apply(query)
          end
        end

        return query
      end

    end
  end
end
