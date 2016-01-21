require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceSingleVatPdf, pdfs: true do
  before :each do
    ::Dorsale::BillingMachine.vat_mode = :single
  end

  let(:customer) {
    create(:customer_vault_corporation)
  }

  let(:id_card) { create(:billing_machine_id_card,
    entity_name: "HEYHO",
    registration_city: 'RCS MARSEILLE',
    registration_number: '000 000 000',
    siret: '000 000 000 00000',
    ape_naf: '0000A',
    legal_form: 'SARL',
    capital: 1_000_000_000,
    intracommunity_vat: 'FR 00 000 000 000 000 00',
    address1: '42 Avenue de Ruby', zip: '13004',
    city: 'Marseille',
    contact_full_name: 'Jane Doe',
    contact_phone: '+33.6.00.00.00.00',
    contact_fax: '+33.9.00.00.00.00',
    contact_email: 'email@example.org',
    iban: 'FR76 0000 0000 0000 0000 0000 000',
    bic_swift: 'PSSTTHEGAME',
    custom_info_1: "Tout retard de règlement donnera lieu de plein droit et sans qu’aucune mise en demeure ne soit nécessaire au paiement de " +
        'pénalités de retard sur la base du taux BCE majoré de dix (10) points et au paiement d’une indemnité forfaitaire pour frais de ' +
        'recouvrement d’un montant de 999999€'
    ) }

  let(:invoice) {

    i = create(:billing_machine_invoice,
      date: '16/04/2014',
      id_card: id_card,
      customer: customer,
      commercial_discount: 100.23,
      advance: 1.79,
    )

    create(:billing_machine_invoice_line,
    invoice: i,
    quantity: 3.14,
    unit: 'heures',
    unit_price: 2.54,
    vat_rate: 19.6,
    total: 7.98)

    create(:billing_machine_invoice_line,
    invoice: i,
    label: 'Truc',
    quantity: 42.42,
    unit: 'nuts',
    unit_price: 42.54,
    vat_rate: 19.6,
    total: 1804.55)

    i.reload
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

  describe "#initialize" do
    it 'inherits from Prawn::Document' do
      expect(pdf).to be_kind_of(Prawn::Document)
    end

    it 'should assign @main_document' do
       expect(pdf.main_document).to eq invoice
    end
  end

  describe 'when the id card is empty' do
    let(:id_card) {
      ::Dorsale::BillingMachine::IdCard.create(id_card_name: 'default')
    }
    it 'should not crash' do
      pdf.build
    end
  end

  describe 'Id card informations' do
    it 'is expected to print the right information' do
      expect(content).to include 'HEYHO'
      expect(content).to include 'SIRET 000 000 000 00000 '
      expect(content).to include 'SARL au capital de 1.000.000.000 €'
      expect(content).to include 'RCS MARSEILLE 000 000 000'
      expect(content).to include 'TVA FR 00 000 000 000 000 00'
      expect(content).to include '42 Avenue de Ruby'
      expect(content).to include '13004 Marseille'
    end
  end

  describe 'Header' do
    it "should write invoice tracking id" do
      expect(content).to include 'Facture'
      expect(content).to include 'n°'
      expect(content).to include invoice.tracking_id
    end

    it "is expected to print invoice date" do
      expect(content).to include 'Date : ' + '16/04/2014'
    end

    it 'is expected to print contact informations' do
      expect(content).to include 'Jane Doe'
      expect(content).to include 'Téléphone :'
      expect(content).to include ' +33.6.00.00.00.00'
      expect(content).to include 'Fax :'
      expect(content).to include ' +33.9.00.00.00.00'
      expect(content).to include 'Email :'
      expect(content).to include ' email@example.org'
    end
  end

  describe 'customer information' do
    it "should write customer name" do
      expect(content).to include invoice.customer.name
    end

    it "is expected to print customer address" do
      expect(content).to include invoice.customer.address.street
      expect(content).to include invoice.customer.address.street_bis
    end

    it "is expected to print customer zip and city" do
      expect(content).to include invoice.customer.address.zip.to_s +
       ' ' + invoice.customer.address.city.to_s
    end

   it "is expected to print 'Objet :' and invoice label" do
     expect(content).to include 'Objet : '
     expect(content).to include invoice.label
    end
  end

  describe "product table" do
    it "is expected to print the header" do
      expect(content).to include 'DÉSIGNATION'
      expect(content).to include 'QTITÉ'
      expect(content).to include 'UNITÉ'
      expect(content).to include 'P.U €HT'
      expect(content).to include 'TOTAL €HT'
    end
    it 'is expected to print invoice line label of each invoice line' do
      invoice.lines.each do |line|
        expect(content).to include line.label
      end
    end

    it 'is expected to print invoice line quantity of each line' do
      expect(content).to include '3,14'
      expect(content).to include '42,42'
    end

    it 'is expected to print invoice line unit_price of each line' do
      expect(content).to include '2,54 €'.gsub(" ", "\u00A0")
      expect(content).to include '42,54 €'.gsub(" ", "\u00A0")
    end

    it 'is expected to print invoice line total of each line' do
      expect(content).to include '7,98 €'.gsub(" ", "\u00A0")
      expect(content).to include '1 804,55 €'.gsub(" ", "\u00A0")
    end
  end

  describe 'Total table' do
    it 'is expected to print all the invoice synthesis' do
      expect(content).to include 'REMISE'
      expect(content).to include '- '+'100,23 €'.gsub(" ", "\u00A0")
      expect(content).to include 'TOTAL HT'
      expect(content).to include '1 712,29 €'.gsub(" ", "\u00A0")
      expect(content).to include 'TVA 19,60 %'
      expect(content).to include '335,61 €'.gsub(" ", "\u00A0")
      expect(content).to include 'ACOMPTE'
      expect(content).to include '1,79 €'.gsub(" ", "\u00A0")
      expect(content).to include 'TOTAL TTC'
      expect(content).to include '2 046,11 €'.gsub(" ", "\u00A0")
    end
  end


  describe 'Footer' do
    it 'is expected to print invoice payment term' do
      expect(content).to include 'Conditions de paiement :'
      expect(content).to include invoice.payment_term.label
    end

    it 'is expected to print current and total page number' do
      expect(content).to include 'page 1/1'
    end

    it 'is expected to print invoice legals and banks' do
      expect(content).to include 'IBAN : FR76 0000 0000 0000 0000 0000 000'
      expect(content).to include 'BIC / SWIFT : PSSTTHEGAME'
      expect(content).to include 'Tout retard de règlement donnera lieu de plein droit et sans qu’aucune mise en demeure ne soit nécessaire au paiement de'
      expect(content).to include 'pénalités de retard sur la base du taux BCE majoré de dix (10) points et au paiement d’une indemnité forfaitaire pour frais de'
      expect(content).to include 'recouvrement d’un montant de 999999€'
    end
  end

  describe 'incomplete invoice' do
    before(:each) do
      invoice_incomplete=create(:billing_machine_invoice,
        advance: 0,
        customer: customer,
        date: '2014-04-16',
        id_card: id_card,
      )
      pdf_incomplete = invoice_incomplete.pdf
      pdf_incomplete.build
      tempfile = Tempfile.new("pdf")
      tempfile.binmode
      tempfile.write(pdf_incomplete.render)
      tempfile.flush
      @incomplete_content = Yomu.new(tempfile.path).text
    end

    it 'is expected not to print ACOMPTE' do
      expect(@incomplete_content).to_not include 'ACOMPTE'
    end

    it 'is expected not to print REMISE' do
      expect(@incomplete_content).to_not include 'REMISE'
    end

    it 'is expected to print TOTAL TTC' do
      expect(@incomplete_content).to include 'TOTAL TTC'
    end
  end
end
