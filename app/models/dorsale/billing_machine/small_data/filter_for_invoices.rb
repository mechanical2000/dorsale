module Dorsale
  module BillingMachine
    module SmallData
      class FilterForInvoices < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          'customer_guid'  => FilterStrategyByCustomer.new('invoices'),
          'time_period'    => FilterStrategyByTimePeriod.new('invoices'),
          'payment_status' => FilterStrategyByPaymentStatus.new('invoices'),
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          'invoices'
        end
      end
    end
  end
end
