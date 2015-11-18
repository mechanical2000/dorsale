require "rails_helper"

RSpec.describe Dorsale::BillingMachine do
  let(:bm) {
    ::Dorsale::BillingMachine
  }

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
    }.to raise_error
  end


end
