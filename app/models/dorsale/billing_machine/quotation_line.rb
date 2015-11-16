module Dorsale
  module BillingMachine
    class QuotationLine < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_quotation_lines"

      belongs_to :quotation, inverse_of: :lines
      default_scope -> {
        order(:created_at => :asc)
      }

      before_save :update_total

      def update_total
        self.quantity   ||= 0
        self.unit_price ||= 0
        self.vat_rate   ||= 20
        self.total       = self.quantity * self.unit_price
      end

      after_save :update_quotation_total

      def update_quotation_total
        self.quotation.reload.save!
      end

    end
  end
end
