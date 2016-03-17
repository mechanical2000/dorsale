module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByTimePeriod < ::Dorsale::SmallData::FilterStrategyByKeyValue
        def apply(query, value)
          criteria = "#{query.model.table_name}.#{key}"

          if value == "today"
            return query.where("#{criteria} >= ?", Date.today)
          elsif value == "week"
            return query.where("#{criteria} >= ?", Date.today.at_beginning_of_week)
          elsif value == "month"
            return query.where("#{criteria} >= ?", Date.today.at_beginning_of_month)
          else
            return query
          end
        end
      end
    end
  end
end
