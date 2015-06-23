module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByTimePeriod < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          if query.model.attribute_names.include?("day")
            field = :day
          else
            field = :date
          end

          criteria = "#{query.model.table_name}.#{field}"

          if @value == "today"
            return query.where("#{criteria} >= ?", Date.today)
          elsif @value == "week"
            return query.where("#{criteria} >= ?", Date.today.at_beginning_of_week)
          elsif @value == "month"
            return query.where("#{criteria} >= ?", Date.today.at_beginning_of_month)
          else
            return query
          end
        end
      end
    end
  end
end
