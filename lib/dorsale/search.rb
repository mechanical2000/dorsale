module Dorsale
  module Search
    def self.included(klass)
      klass.send(:extend, Dorsale::Search::ClassMethods)
    end
    
    module ClassMethods
      def default_search_fields
        fields = columns.map do |column|
          "#{table_name}.#{column.name}"
        end
      end
      
      def search(q, *fields)
        words  = q.to_s.parameterize.split("-")
        fields = default_search_fields if fields.empty?
        
        sql_query = words.map.with_index do |word, index|
          fields.map do |field|
            "(LOWER(CAST(#{field} AS TEXT)) LIKE :w#{index})"
          end.join(" OR ")
        end.map{ |e| "(#{e})" }.join(" AND ")
        
        sql_params_a = words.map.with_index do |word, index|
          ["w#{index}".to_sym, "%#{word}%"]
        end
        
        sql_params_h = Hash[sql_params_a]
        
        self.where(sql_query, sql_params_h)
      end
    end
  end
end
