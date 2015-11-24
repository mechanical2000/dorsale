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

  let(:pdf) {
    invoice.pdf
  }

  let(:content) {
    tempfile = Tempfile.new("pdf")
    tempfile.binmode
    tempfile.write(pdf.render)
    tempfile.flush
    Yomu.new(tempfile.path).text
  }

  it "should not display global vat rate" do
    expect(content).to_not include "TVA 19,60 %"
    expect(content).to include "MONTANT TVA"
    expect(content).to include "TVA %"
  end

end
