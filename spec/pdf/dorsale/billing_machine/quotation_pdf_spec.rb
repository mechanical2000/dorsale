require "rails_helper"

describe ::Dorsale::BillingMachine::InvoicePdf, pdfs: true do

  def self.it_should_write(string)
    it "should write '#{string}'" do
      text.strings.should include string
    end
  end

  def self.it_should_not_write(string)
    it "should write '#{string}'" do
      text.strings.should_not include string
    end
  end

  let(:customer) {
    create(:person)
  }

  let(:id_card) { create(:id_card,
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
    custom_info_1: "Mention légale" + "\n" + "Tout retard de règlement donnera lieu de plein droit et sans qu’aucune mise en demeure ne soit nécessaire au paiement de " +
        'pénalités de retard sur la base du taux BCE majoré de dix (10) points et au paiement d’une indemnité forfaitaire pour frais de ' +
        'recouvrement d’un montant de 999999€'
    ) }

  let(:quotation) { create(:quotation,
      date: '16/04/2014',
      id_card: id_card,
      customer: customer,
      total_duty: 1812.53,
      vat_amount: 355.26,
      total_all_taxes: 2167.79,
      vat_rate: 19.6,
      comments: 'this is the quotation comment') }

  let(:quotation_line) { create(:quotation_line,
    quotation_id: quotation.id,
    quantity: 3.14,
    unit: 'heures',
    unit_price: 2.54,
    total: 7.98) }

  let(:quotation_line_2) { create(:quotation_line,
    quotation_id: quotation.id,
    label: 'Truc',
    quantity: 42.42,
    unit: 'nuts',
    unit_price: 42.54,
    total: 1804.55) }

  let(:pdf) { build(:common_quotation, quotation: quotation) }

  describe "#initialize" do
    it 'inherits from Prawn::Document' do
      pdf.should be_kind_of(Prawn::Document)
    end

    it 'inherits from CommonQuotation' do
      pdf.should be_kind_of(CommonQuotation)
    end

    it 'should assign @main_document' do
      pdf.main_document.should eq(quotation)
    end
  end

  describe "#build" do
    let(:text) { PDF::Inspector::Text.analyze(pdf.render) }

    context 'when the id card is empty' do
      let(:id_card) { IdCard.create(id_card_name: 'default', entity: create(:entity))}
      it 'should not crash' do
      end
    end

    before do
      quotation.lines << quotation_line
      quotation.lines << quotation_line_2
      pdf.build
    end
    context 'in Mentions légales - Coin supérieur droit' do
      it_should_write 'HEYHO'
      it_should_write 'SIRET 000 000 000 00000 APE 0000A'
      it_should_write 'SARL au capital de 1.000.000.000 euros'
      it_should_write 'RCS MARSEILLE 000 000 000'
      it_should_write 'N° TVA FR 00 000 000 000 000 00'
      it_should_write '42 Avenue de Ruby'
      it_should_write '13004 Marseille'
    end

    context 'in Entete de facturation' do

    it_should_write 'Devis'

    it "should write invoice tracking id" do
      text.strings.should include ' N°' + quotation.tracking_id
    end
    it "should write 'Marseille le ' and invoice date" do
      text.strings.should include 'Marseille le ' + '16 avril 2014'
    end

      context 'in Informations contact' do
        it_should_write 'Contact :'
        it_should_write ' Jane Doe'
        it_should_write 'Tél :'
        it_should_write ' +33.6.00.00.00.00'
        it_should_write 'Fax:'
        it_should_write ' +33.9.00.00.00.00'
        it_should_write 'Email:'
        it_should_write ' email@example.org'
      end

      context 'in Informations client' do
        it_should_write 'A l’attention de :'

        it "should write customer name" do
          text.strings.should include quotation.customer.name
        end

        it "should write customer address" do
          text.strings.should include quotation.customer.address.street
          text.strings.should include quotation.customer.address.street_bis
        end

        it "should write customer zip and city" do
          text.strings.should include quotation.customer.address.zip.to_s +
           ' ' + quotation.customer.address.city.to_s
        end

        it "should write customer country" do
          text.strings.should include quotation.customer.address.country
        end
      end # context in Informations client
    end # context in Entete de facturation

    it "shoud write 'Objet :' and invoice label" do
      text.strings.should include 'Objet :'
      text.strings.should include ' ' + quotation.label
    end

    context "in Tableau" do
      it_should_write 'Prestation'
      it_should_write 'Prix'
      it_should_write 'unitaire'
      it_should_write 'Quantité'
      it_should_write 'Total HT'


      context "in Lignes de facturation" do
        it 'should write invoice line label of each invoice line' do
          quotation.lines.each do |line|
            text.strings.should include line.label
          end
        end

        it 'should write invoice line quantity of each line' do
          text.strings.should include '3,14'
          text.strings.should include '42,42'
        end

        it 'should write invoice line unit_price of each line' do
          text.strings.should include '2,54 €'
          text.strings.should include '42,54 €'
        end

        it 'should write invoice line total of each line' do
          text.strings.should include '7,98 €'
          text.strings.should include '1.804,55 €'
        end
      end # context in Lignes de facturation

      context 'in Synthèse' do
        it_should_write 'Total HT'
        it_should_write '1.812,52 €'

        it_should_write 'TVA 19,6 %'
        it_should_write '355,25 €'

        it_should_write 'Total TTC'
        it_should_write '2.167,78 €'

        it_should_not_write 'Acompte reçu sur commande'
        it_should_not_write '1,79 €'

        it_should_not_write 'Solde à payer'
        it 'should write balance calculated using total_all_taxes - advance' do
          text.strings.should_not include '2.165,99 €'
        end

      end
    end # context in Tableau
    it_should_write 'Conditions de paiement :'

    it 'should write invoice payment term' do
      text.strings.should include quotation.payment_term.label
    end

    it_should_not_write 'Coordonnées bancaires :'
    it_should_not_write 'IBAN : FR76 0000 0000 0000 0000 0000 000'
    it_should_not_write 'BIC / SWIFT : PSSTTHEGAME'

    context 'in Comments - Bas de page' do
      it_should_write 'this is the quotation comment'
    end

    context 'in Mentions légales - Bas de page' do
      it_should_write 'Mention légale'
      it_should_write 'Tout retard de règlement donnera lieu de plein droit et sans qu’aucune mise en demeure ne soit nécessaire au paiement de'
      it_should_write 'pénalités de retard sur la base du taux BCE majoré de dix (10) points et au paiement d’une indemnité forfaitaire pour frais de'
      it_should_write 'recouvrement d’un montant de 999999€'
    end
  end # describe #build

  describe "missing data" do
    it "missing payment_term should be OK" do
      quotation = create(:quotation, payment_term: nil)
      pdf     = CommonQuotation.new(quotation)
      pdf.build
      PDF::Inspector::Text.analyze(pdf.render)
    end
  end
end
