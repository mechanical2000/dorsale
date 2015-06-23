module Dorsale
  module BillingMachine
    class Invoice < ActiveRecord::Base
      self.table_name = "dorsale_billing_machine_invoices"

      belongs_to :customer, polymorphic: true
      belongs_to :payment_term
      belongs_to :id_card

      has_many :lines, inverse_of: :invoice, dependent: :destroy, class_name: ::Dorsale::BillingMachine::InvoiceLine

      accepts_nested_attributes_for :lines, allow_destroy: true

      polymorphic_id_for :customer

      validates :id_card, presence: true
      validates :date,    presence: true

      # simple_form
      validates :id_card_id, presence: true

      def initialize(*args)
        super
        self.date     = Date.today       if date.nil?
        self.due_date = 30.days.from_now if due_date.nil?
        self.vat_rate = 20               if vat_rate.nil?
        self.advance  = 0                if advance.nil?
        self.paid     = false            if paid.nil?
      end

      before_create :assign_unique_index

      def assign_unique_index
        if unique_index.nil?
          self.unique_index = self.class.all.pluck(:unique_index).max.to_i.next
        end
      end

      def tracking_id
        date.year.to_s + "-" + unique_index.to_s.rjust(2, "0")
      end

      before_save :update_balance

      def update_balance
        self.vat_rate        = 0 if vat_rate.nil?
        self.advance         = 0 if advance.nil?
        self.total_duty      = lines.pluck(:total).sum
        self.vat_amount      = total_duty * vat_rate / 100.0
        self.total_all_taxes = total_duty + vat_amount
        self.balance         = total_all_taxes - advance
      end

      def pdf
        pdf = ::Dorsale::BillingMachine::InvoicePdf.new(self)
        pdf.build
        pdf
      end

      def payment_status
        if paid?
          return :paid
        elsif due_date == nil
          return :on_alert
        elsif Date.today >= due_date + 15
          return :on_alert
        elsif Date.today > due_date
          return :late
        else
          return :pending
        end
      end

      def self.to_csv(options = { :force_quotes => true, :col_sep => ";" })
        CSV.generate(options) do |csv|
          column_names = [
            "Date",
            "Numéro",
            "Objet",
            "Client",
            "Adresse 1",
            "Adresse 2",
            "Code postal",
            "Ville",
            "Pays",
            "Montant HT",
            "Taux TVA",
            "Montant TVA",
            "Montant TTC",
            "Acompte",
            "Solde à payer"
          ]

          csv << column_names

          all.each do |invoice|
            csv << [
              invoice.date,
              invoice.tracking_id,
              invoice.label,
              invoice.customer.try(:name),
              invoice.customer.try(:address).try(:street),
              invoice.customer.try(:address).try(:street_bis),
              invoice.customer.try(:address).try(:zip),
              invoice.customer.try(:address).try(:city),
              invoice.customer.try(:address).try(:country),
              french_number(invoice.total_duty),
              french_number(invoice.vat_rate),
              french_number(invoice.vat_amount),
              french_number(invoice.total_all_taxes),
              french_number(invoice.advance),
              french_number(invoice.balance)
            ]
          end
        end
      end

      def self.french_number amount
        extend ActionView::Helpers::NumberHelper
        number_with_precision(amount, :delimiter => '', :separator => ",", :precision => 2)
      end

    end # Invoice
  end # BillingMachine
end # Dorsale
