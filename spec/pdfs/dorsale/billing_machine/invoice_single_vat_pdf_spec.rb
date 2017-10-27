require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceSingleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :single
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

  it "should display global vat rate" do
    expect(content).to include "TVA 19,60 %"
    expect(content).to_not include "MONTANT TVA"
    expect(content).to_not include "TVA %"
  end

  describe "empty invoice" do
    let(:invoice) {
      id_card = Dorsale::BillingMachine::IdCard.new
      id_card.save!(validate: false)
      invoice = ::Dorsale::BillingMachine::Invoice.create!(id_card: id_card)
    }

    it "should work" do
      expect { generate! }.to_not raise_error
    end
  end # describe "empty invoice"
end
