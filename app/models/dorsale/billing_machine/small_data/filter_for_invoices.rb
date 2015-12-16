module Dorsale
  module BillingMachine
    module SmallData
      class FilterForInvoices < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "customer_guid"     => FilterStrategyByCustomer.new("invoices"),
          "bm_time_period"    => FilterStrategyByTimePeriod.new("invoices"),
          "bm_payment_status" => FilterStrategyByPaymentStatus.new("invoices"),
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

        def bm_time_period
          get("time_period")
        end

        def bm_payment_status
          get("payment_status")
        end

      end
    end
  end
end
