module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByCustomer < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          type, id = @value.split("-")
          query.where(customer_type: type, customer_id: id)
        end
      end
    end
  end
end
