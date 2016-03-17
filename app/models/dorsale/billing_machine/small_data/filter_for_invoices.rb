module Dorsale
  module BillingMachine
    module SmallData
      class FilterForInvoices < ::Dorsale::SmallData::Filter
        STRATEGIES = {
          "customer_guid"     => FilterStrategyByCustomer.new,
          "bm_time_period"    => FilterStrategyByTimePeriod.new(:date),
          "bm_payment_status" => FilterStrategyByPaymentStatus.new,
        }
      end
    end
  end
end
