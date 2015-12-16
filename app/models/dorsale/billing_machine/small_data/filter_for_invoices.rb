module Dorsale
  module BillingMachine
    module SmallData
      class FilterForInvoices < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "customer_guid"  => FilterStrategyByCustomer.new("invoices"),
          "time_period"    => FilterStrategyByTimePeriod.new("invoices"),
          "payment_status" => FilterStrategyByPaymentStatus.new("invoices"),
        }

        def strategy key
          STRATEGIES[key]
        end

        def target
          "invoices"
        end

        def customer_guid
          get("customer_guid")
        end

        def time_period
          get("time_period")
        end

        def payment_status
          get("payment_status")
        end

      end
    end
  end
end
