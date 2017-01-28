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
    Yomu.new(invoice.pdf_file.path).text
  }

  it "should not display global vat rate" do
    expect(content).to_not include "TVA 19,60 %"
    expect(content).to include "MONTANT TVA"
    expect(content).to include "TVA %"
  end

  describe "empty invoice" do
    let(:invoice) {
      id_card = Dorsale::BillingMachine::IdCard.new
      id_card.save(validate: false)
      invoice = ::Dorsale::BillingMachine::Invoice.create!(id_card: id_card)
    }

    it "should work" do
      expect { generate! }.to_not raise_error
    end
  end # describe "empty invoice"

end
