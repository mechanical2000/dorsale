require "rails_helper"

RSpec.describe Dorsale::BillingMachine do
  let(:bm) {
    ::Dorsale::BillingMachine
  }

  describe "::vat_mode" do
    it "default vat_mode should be :single" do
      expect(bm.vat_mode).to eq :single
      expect(bm.invoice_pdf_model).to eq Dorsale::BillingMachine::InvoiceSingleVatPdf
      expect(bm.quotation_pdf_model).to eq Dorsale::BillingMachine::QuotationSingleVatPdf
    end

    it "vat_mode should accept :multiple value" do
      bm.vat_mode = :multiple
      expect(bm.vat_mode).to eq :multiple
      expect(bm.invoice_pdf_model).to eq Dorsale::BillingMachine::InvoiceMultipleVatPdf
      expect(bm.quotation_pdf_model).to eq Dorsale::BillingMachine::QuotationMultipleVatPdf
    end

    it "vat_mode should not accept :abc value" do
      expect {
        bm.vat_mode = :abc
      }.to raise_error(RuntimeError)
    end
  end # describe "::vat_mode"

  describe "::vat_round_by_line" do
    after { Dorsale::BillingMachine.vat_round_by_line = nil }

    it "should return default value" do
      expect(Dorsale::BillingMachine.vat_round_by_line).to eq false
    end

    it "should assign false value" do
      Dorsale::BillingMachine.vat_round_by_line = false
      expect(Dorsale::BillingMachine.vat_round_by_line).to eq false
    end

    it "should assign true value" do
      Dorsale::BillingMachine.vat_round_by_line = true
      expect(Dorsale::BillingMachine.vat_round_by_line).to eq true
    end
  end # describe "::vat_round_by_line"

  describe "::default_currency" do
    it "default currency should be €" do
      expect(bm.default_currency).to eq "€"
    end

    it "assign an other default currency" do
      bm.default_currency = "$"
      expect(bm.default_currency).to eq "$"
    end
  end # describe "::default_currency"
end
