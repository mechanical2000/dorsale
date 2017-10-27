require "rails_helper"

describe ::Dorsale::BillingMachine::QuotationSingleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :single
  end

  let(:quotation) {
    q = create(:billing_machine_quotation)

    create(:billing_machine_quotation_line,
      :quotation => q,
      :vat_rate  => 19.6,
    )

    q
  }

  let(:generate!) {
    Dorsale::BillingMachine::PdfFileGenerator.(quotation)
    quotation.reload
  }

  let(:content) {
    generate!
    Yomu.new(quotation.pdf_file.path).text
  }

  it "should display global vat rate" do
    expect(content).to include "TVA 19,60 %"
    expect(content).to_not include "MONTANT TVA"
    expect(content).to_not include "TVA %"
  end

  it "should work with empty quotation" do
    quotation = ::Dorsale::BillingMachine::Quotation.new

    expect {
      described_class.new(quotation).tap(&:build).render_with_attachments
    }.to_not raise_error
  end

  describe "attachments" do
    let(:quotation) {
      quotation  = create(:billing_machine_quotation)
      attachment = create(:alexandrie_attachment, attachable: quotation)
      quotation
    }

    it "should build attachments" do
      expect(content).to include "page 1"
      expect(content).to include "page 2"
    end
  end # describe "attachments"
end
