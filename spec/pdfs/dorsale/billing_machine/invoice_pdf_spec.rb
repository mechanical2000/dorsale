require "rails_helper"

describe ::Dorsale::BillingMachine::InvoicePdf, pdfs: true do

  def self.it_should_write(string)
    it "should write '#{string}'" do
      text.strings.should include string
    end
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

  let(:invoice) { create(:billing_machine_invoice,
      date: '16/04/2014',
      id_card: id_card,
      customer: customer,
      commercial_discount: 100.23,
      total_duty: 1812.53,
      vat_amount: 355.26,
      total_all_taxes: 2167.79,
      advance: 1.79,
      vat_rate: 19.6,
      balance: 2166.0) }

  let(:invoice_line) { create(:billing_machine_invoice_line,
    invoice_id: invoice.id,
    quantity: 3.14,
    unit: 'heures',
    unit_price: 2.54,
    total: 7.98) }

  let(:invoice_line_2) { create(:billing_machine_invoice_line,
    invoice_id: invoice.id,
    label: 'Truc',
    quantity: 42.42,
    unit: 'nuts',
    unit_price: 42.54,
    total: 1804.55) }

  let(:pdf) {
    invoice.pdf
  }

  describe "#initialize" do
    it 'inherits from Prawn::Document' do
      pdf.should be_kind_of(Prawn::Document)
    end

    it 'should assign @main_document' do
      pdf.main_document.should eq(invoice)
    end
  end

  describe "#build" do
    let(:text) { PDF::Inspector::Text.analyze(pdf.render) }

    context 'when the id card is empty' do
      let(:id_card) {
        ::Dorsale::BillingMachine::IdCard.create(id_card_name: 'default')
      }
      it 'should not crash' do
        pdf.build
      end
    end

    before do
      invoice.lines << invoice_line
      invoice.lines << invoice_line_2
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

    it_should_write 'Facture'

    it "should write invoice tracking id" do
      text.strings.should include ' N°' + invoice.tracking_id
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
          text.strings.should include invoice.customer.name
        end

        it "should write customer address" do
          text.strings.should include invoice.customer.address.street
          text.strings.should include invoice.customer.address.street_bis
        end

        it "should write customer zip and city" do
          text.strings.should include invoice.customer.address.zip.to_s +
           ' ' + invoice.customer.address.city.to_s
        end

        it "should write customer country" do
          text.strings.should include invoice.customer.address.country
        end
      end # context in Informations client
    end # context in Entete de facturation

    it "shoud write 'Objet :' and invoice label" do
      text.strings.should include 'Objet :'
      text.strings.should include ' ' + invoice.label
    end

    context "in Tableau" do
      it_should_write 'Prestation'
      it_should_write 'Prix'
      it_should_write 'unitaire'
      it_should_write 'Quantité'
      it_should_write 'Total HT'


      context "in Lignes de facturation" do
        it 'should write invoice line label of each invoice line' do
          invoice.lines.each do |line|
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

        it_should_write 'Remise commerciale'
        it_should_write '100,23 €'

        it_should_write 'Total HT'
        it_should_write '1.712,29 €'

        it_should_write 'TVA 19,6 %'
        it_should_write '335,61 €'

        it_should_write 'Total TTC'
        it_should_write '2.047,90 €'

        it_should_write 'Acompte reçu sur commande'
        it_should_write '1,79 €'

        it_should_write 'Solde à payer'
        it 'should write balance calculated using total_all_taxes - advance' do
          text.strings.should include '2.046,11 €'
        end


        context 'without advance' do

          before(:each) do
            invoice_incomplete=create(:billing_machine_invoice, total_duty: 1000, vat_amount: 196,
              total_all_taxes: 1196, advance: 0, balance: 1146 , customer: customer,
              date: '2014-04-16', vat_rate: 19.6, id_card: id_card)
            pdf_incomplete = invoice_incomplete.pdf
            pdf_incomplete.build
            @text_incomplete = PDF::Inspector::Text.analyze(pdf_incomplete.render)
          end

          it 'should not write Acompte reçu sur commande' do
            @text_incomplete.strings.should_not include 'Acompte reçu sur commande'
          end

          it 'should not write Remise commerciale' do
            @text_incomplete.strings.should_not include 'Remise commerciale'
          end

          it 'should not write Solde à payer' do
            @text_incomplete.strings.should_not include 'Solde à payer'
          end

        end
      end
    end # context in Tableau
    it_should_write 'Conditions de paiement :'

    it 'should write invoice payment term' do
      text.strings.should include invoice.payment_term.label
    end

    it_should_write 'Coordonnées bancaires :'
    it_should_write 'IBAN : FR76 0000 0000 0000 0000 0000 000'
    it_should_write 'BIC / SWIFT : PSSTTHEGAME'

    context 'in Mentions légales - Bas de page' do
      it_should_write 'Mention légale'
      it_should_write 'Tout retard de règlement donnera lieu de plein droit et sans qu’aucune mise en demeure ne soit nécessaire au paiement de'
      it_should_write 'pénalités de retard sur la base du taux BCE majoré de dix (10) points et au paiement d’une indemnité forfaitaire pour frais de'
      it_should_write 'recouvrement d’un montant de 999999€'
    end
  end # describe #build

  describe "missing data" do
    it "missing payment_term should be OK" do
      invoice = create(:billing_machine_invoice, payment_term: nil)
      pdf     = invoice.pdf
      pdf.build
      PDF::Inspector::Text.analyze(pdf.render)
    end
  end
end
