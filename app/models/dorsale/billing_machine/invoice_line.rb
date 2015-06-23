module Dorsale
  module BillingMachine
    class InvoiceLine < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_invoice_lines"

      belongs_to :invoice, inverse_of: :lines

      default_scope -> {
        order(created_at: :asc)
      }

      before_save :update_total

      def update_total
        self.quantity   ||= 0
        self.unit_price ||= 0
        self.total = self.quantity * self.unit_price
      end

      # ???
      after_save do
        self.invoice.reload.save
      end

    end
  end
end
