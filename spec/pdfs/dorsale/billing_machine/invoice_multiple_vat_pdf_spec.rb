require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceMultipleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :multiple
  end

  let(:invoice) {
    i = create(:billing_machine_invoice)

    create(:billing_machine_invoice_line,
      :invoice  => i,
      :vat_rate => 19.6,
    )

    i
  }

  let(:generate!) {
    Dorsale::BillingMachine::PdfFileGenerator.(invoice)
    invoice.reload
  }

  let(:content) {
    generate!
    PDF::Reader.new(invoice.pdf_file.path).pages.map(&:text).join("\n")
  }

  it "should not display global vat rate" do
    expect(content).to_not include "TVA 19,60 %"
    expect(content).to include "MONTANT TVA"
    expect(content).to include "TVA %"
  end

  it "should work with empty invoice" do
    invoice = ::Dorsale::BillingMachine::Invoice.new

    expect {
      described_class.new(invoice).tap(&:build).render_with_attachments
    }.to_not raise_error
  end
end
