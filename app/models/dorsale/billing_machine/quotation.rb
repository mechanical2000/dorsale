module Dorsale
  module BillingMachine
    class Quotation < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_quotations"

      STATES = %w(pending accepted refused canceled)

      belongs_to :customer, polymorphic: true
      belongs_to :id_card
      belongs_to :payment_term
      has_many :lines,
        :inverse_of => :quotation,
        :dependent  => :destroy,
        :class_name => ::Dorsale::BillingMachine::QuotationLine

      has_many :attachments,
        :as         => :attachable,
        :dependent  => :destroy,
        :class_name => ::Dorsale::Alexandrie::Attachment

      accepts_nested_attributes_for :lines, allow_destroy: true

      polymorphic_id_for :customer

      validates :id_card, presence: true
      validates :date,    presence: true
      validates :state,   presence: true, inclusion: {in: STATES}

      # simple_form
      validates :id_card_id, presence: true

      def initialize(*)
        super
        self.state                 = STATES.first          if state.nil?
        self.date                  = Time.zone.now.to_date if date.nil?
        assign_default_values
      end

      before_create :assign_unique_index
      before_create :assign_tracking_id
      before_validation :assign_default_values

      def assign_unique_index
        if unique_index.nil?
          self.unique_index = self.class.all.pluck(:unique_index).max.to_i.next
        end
      end

      def assign_tracking_id
        self.tracking_id = date.year.to_s + "-" + unique_index.to_s.rjust(2, "0")
      end

      def assign_default_values
        self.expires_at            = date + 1.month if expires_at.nil?
        self.commercial_discount   = 0              if commercial_discount.nil?
        self.vat_amount            = 0              if vat_amount.nil?
        self.total_excluding_taxes = 0              if total_excluding_taxes
      end

      before_save :update_totals

      def update_totals
        assign_default_values
        lines_sum = lines.map(&:total).sum

        self.total_excluding_taxes = lines_sum - commercial_discount

        if commercial_discount.nonzero? && lines_sum.nonzero?
          discount_rate = commercial_discount / lines_sum
        else
          discount_rate = 0.0
        end

        self.vat_amount = 0.0

        lines.each do |line|
          line_total = line.total - (line.total * discount_rate)
          self.vat_amount += (line_total * line.vat_rate / 100.0)
        end

        self.total_including_taxes = total_excluding_taxes + vat_amount
      end

      def total_excluding_taxes=(*); super; end
      private :total_excluding_taxes=

      def vat_amount=(*); super; end
      private :vat_amount=

      def total_including_taxes=(*); super; end
      private :total_including_taxes=

      def balance
        self.total_including_taxes
      end

      def vat_rate
        if ::Dorsale::BillingMachine.vat_mode == :multiple
          raise "Quotation#vat_rate is not available in multiple vat mode"
        end

        return @vat_rate if @vat_rate

        vat_rates = lines.map(&:vat_rate).uniq

        if vat_rates.length > 1
          raise "Quotation has multiple vat rates"
        end

        vat_rates.first || ::Dorsale::BillingMachine::DEFAULT_VAT_RATE
      end

      def vat_rate=(value)
        @vat_rate = value
      end

      before_validation :apply_vat_rate_to_lines

      def apply_vat_rate_to_lines
        return if ::Dorsale::BillingMachine.vat_mode == :multiple

        lines.each do |line|
          line.vat_rate = vat_rate
        end
      end

      def pdf
        pdf = ::Dorsale::BillingMachine.quotation_pdf_model.new(self)
        pdf.build
        pdf
      end

      def create_copy!
        new_quotation = self.dup

        self.lines.each do |line|
          new_quotation.lines << line.dup
        end

        new_quotation.unique_index = nil
        new_quotation.created_at   = nil
        new_quotation.updated_at   = nil
        new_quotation.date         = Time.zone.now.to_date
        new_quotation.state        = Quotation::STATES.first

        new_quotation.save!

        self.attachments.each do |attachment|
          new_attachment            = attachment.dup
          new_attachment.attachable = new_quotation
          new_attachment.file       = File.open(attachment.file.path)
          new_attachment.save!
        end

        new_quotation
      end

      def to_new_invoice
        new_invoice = Dorsale::BillingMachine::Invoice.new

        self.attributes.each do |k, v|
          next if k.to_s == "id"
          next if k.to_s.match /index|tracking|_at/

          if new_invoice.respond_to?("#{k}=")
            new_invoice.public_send("#{k}=", v)
          end
        end

        self.lines.each do |line|
          new_line = new_invoice.lines.new
          line.attributes.each do |k, v|
            next if k.to_s == "id"
            next if k.to_s.match /index|tracking|_at/

          if new_line.respond_to?("#{k}=")
            new_line.public_send("#{k}=", v)
          end
          end
        end

        new_invoice.date = Time.zone.now.to_date

        new_invoice
      end

    end # Quotation
  end # BillingMachine
end # Dorsale
