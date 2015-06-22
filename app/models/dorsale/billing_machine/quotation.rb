module Dorsale
  module BillingMachine
    class Quotation < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_quotations"

      belongs_to :customer, polymorphic: true
      belongs_to :id_card
      belongs_to :payment_term

      has_many :lines,  inverse_of: :quotation, dependent: :destroy, class_name: ::Dorsale::BillingMachine::QuotationLine

      accepts_nested_attributes_for :lines, allow_destroy: true

      polymorphic_id_for :customer

      validates :id_card, presence: true
      validates :date,    presence: true

      before_create :assign_unique_index

      def assign_unique_index
        if unique_index.nil?
          self.unique_index = self.class.all.pluck(:unique_index).max.to_i.next
        end
      end

      def tracking_id
        date.year.to_s + "-" + unique_index.to_s.rjust(2, "0")
      end

      before_save :update_total

      def update_total
        self.vat_rate ||= 0
        self.total_duty = self.lines.map(&:total).delete_if {|e| e.blank?}.inject(:+) || 0
        self.vat_amount = self.total_duty * self.vat_rate / 100.0
        self.total_all_taxes = self.total_duty + self.vat_amount
      end

      def pdf
        pdf = ::Dorsale::BillingMachine::CommonQuotation.new(self)
        pdf.build
        pdf
      end

    end # Quotation
  end # BillingMachine
end # Dorsale
