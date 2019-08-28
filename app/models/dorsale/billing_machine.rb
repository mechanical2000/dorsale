module Dorsale::BillingMachine
  class << self
    def vat_modes
      [:single, :multiple]
    end

    def vat_mode
      @vat_mode ||= :single
    end

    def vat_mode=(new_mode)
      raise "invalid mode #{new_mode}" unless vat_modes.include?(new_mode)
      @vat_mode = new_mode
    end

    def vat_round_by_line
      @vat_round_by_line = false if @vat_round_by_line.nil?
      @vat_round_by_line
    end

    attr_writer :vat_round_by_line

    def invoice_pdf_model
      "::Dorsale::BillingMachine::Invoice#{vat_mode.to_s.capitalize}VatPdf".constantize
    end

    def quotation_pdf_model
      "::Dorsale::BillingMachine::Quotation#{vat_mode.to_s.capitalize}VatPdf".constantize
    end

    attr_writer :default_currency

    def default_currency
      @default_currency ||= "€"
    end

    attr_writer :default_vat_rate

    def default_vat_rate
      @default_vat_rate ||= 20.0
    end
  end
end
