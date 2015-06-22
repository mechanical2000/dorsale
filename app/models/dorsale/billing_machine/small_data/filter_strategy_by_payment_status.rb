module Dorsale
  module BillingMachine
    module SmallData
      class FilterStrategyByPaymentStatus < ::Dorsale::SmallData::FilterStrategy
        def do_apply query
          if (@value == 'paid')
            return query.where('invoices.paid = ?', true)
          elsif (@value == 'unpaid')
            return query.where('invoices.paid = ?', false)
          elsif (@value == 'pending')
            return query.where('invoices.paid = ? and invoices.due_date >= ?', false, Date.today)
          elsif (@value == 'late')
            return query.where('invoices.paid = ? and (invoices.due_date < ? or invoices.due_date is null)', false, Date.today)
          else
            return query
          end
        end
      end
    end
  end
end
