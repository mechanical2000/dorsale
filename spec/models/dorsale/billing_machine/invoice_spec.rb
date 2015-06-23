require "rails_helper"

describe ::Dorsale::BillingMachine::Invoice, type: :model do
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :payment_term }
  it { is_expected.to have_many :lines }

  it { is_expected.to validate_presence_of :id_card }
  it { is_expected.to validate_presence_of :date }

  it "should have a valid factory" do
    expect(create(:billing_machine_invoice)).to be_valid
  end

  describe "unique_index" do
    context "when unique index is 69" do
      it "should be assigned upon creation" do
        invoice1 = create(:billing_machine_invoice, date: "2014-02-01", unique_index: 69)
        invoice2 = create(:billing_machine_invoice, date: "2014-02-01")
        expect(invoice2.unique_index).to eq(70)
      end
    end

    context "when unique index is nil" do
      it "should be assigned upon creation" do
        ::Dorsale::BillingMachine::Invoice.destroy_all
        invoice1 = create(:billing_machine_invoice, date: "2014-02-01")
        expect(invoice1.unique_index).to eq(1)
      end
    end
  end

  describe "tracking_id" do
    it "should return correct tracking_id" do
      invoice = create(:billing_machine_invoice, date: "2014-02-01")
      expect(invoice.tracking_id).to eq("2014-01")
    end
  end

  describe "payment_status" do
    it "should be pending if nothing special" do
      invoice = create(:billing_machine_invoice, due_date: Date.today, date: Date.today, paid: false)
      expect(invoice.payment_status).to eq(:pending)
    end

    it "should be late if a bit late" do
        invoice = create(:billing_machine_invoice, due_date: Date.today-1, date: Date.today-1, paid: false)
        expect(invoice.payment_status).to eq(:late)
    end

    it "should be on_alert if a too late" do
        invoice = create(:billing_machine_invoice, due_date: Date.today-16, date: Date.today-16, paid: false)
        expect(invoice.payment_status).to eq(:on_alert)
    end

    it "should be paid if paid" do
        invoice = create(:billing_machine_invoice, due_date: Date.today-16, date: Date.today-16, paid: true)
        expect(invoice.payment_status).to eq(:paid)
    end

    it "should be on_alert if no due date is defined" do
        invoice = create(:billing_machine_invoice, due_date: nil, date: Date.today, paid: false)
        expect(invoice.payment_status).to eq(:on_alert)
    end

    it "should be on_alert if no due date is defined" do
        invoice = create(:billing_machine_invoice, due_date: nil, date: Date.today, paid: true)
        expect(invoice.payment_status).to eq(:paid)
    end

    it "should work fine upon creation" do
      invoice = build(:billing_machine_invoice)
      invoice.lines << ::Dorsale::BillingMachine::InvoiceLine.new(quantity: 1, unit_price: 10)
      invoice.lines << ::Dorsale::BillingMachine::InvoiceLine.new(quantity: 1, unit_price: 10)
      invoice.save
    end
  end

  describe "paid" do
    it "should be false by default" do
      invoice = create(:billing_machine_invoice)
      expect(invoice.paid).to eq(false)
    end
  end

  describe "totals" do
    it "should be calculated upon saving" do
      invoice = create(:billing_machine_invoice, vat_rate: 20, total_duty: 0, vat_amount: 0, total_all_taxes: 0, advance: 40, balance: 0)
      create(:billing_machine_invoice_line, quantity: 10, unit_price: 5, invoice: invoice)
      create(:billing_machine_invoice_line, quantity: 10, unit_price: 5, invoice: invoice)
      expect(invoice.total_duty).to eq(100.0)
      expect(invoice.vat_amount).to eq(20.0)
      expect(invoice.total_all_taxes).to eq(120.0)
      expect(invoice.balance).to eq(80.0)
    end
    it "should be calculated upon saving" do
      invoice = create(:billing_machine_invoice, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil, advance: nil, balance: nil)
      create(:billing_machine_invoice_line, quantity: 10, unit_price: 5, invoice: invoice)
      create(:billing_machine_invoice_line, quantity: 10, unit_price: 5, invoice: invoice)

      expect(invoice.total_duty).to eq(100.0)
      expect(invoice.vat_amount).to eq(0.0)
      expect(invoice.total_all_taxes).to eq(100.0)
      expect(invoice.balance).to eq(100.0)
    end

    it "should work fine even with empty lines" do
      invoice = create(:billing_machine_invoice, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil, advance: nil, balance: nil)
      create(:billing_machine_invoice_line, quantity: nil, unit_price: nil, invoice: invoice)
      expect(invoice.total_duty).to eq(0.0)
    end
  end

  describe 'to_csv' do
    let(:id_card) { create(:billing_machine_id_card) }
    let(:customer) {
      create(:customer_vault_corporation,
        :name => "cutomerName",
        :address_attributes => {
          :street     => "address1",
          :street_bis => "address2",
          :zip        => "13005",
          :city       => "Marseille",
          :country    => "country",
        }
      )
    }

    let(:columns_names) {'"Date";"Numéro";"Objet";"Client";"Adresse 1";"Adresse 2";"Code postal";"Ville";"Pays";"Montant HT";"Taux TVA";"Montant TVA";"Montant TTC";"Acompte";"Solde à payer"'+"\n"}
    it 'should return csv', ignore_semaphore: true do
      invoice0 = create(:billing_machine_invoice, label: "invoiceLabel", date: "2014-07-31", unique_index: 1, total_duty: 9.99, vat_rate: 19.6, vat_amount: 23.2, total_all_taxes: 43.35, advance: 3.5, id_card: id_card, customer: customer)
      invoice0.lines.create(quantity: 1, unit_price: 9.99)
      invoice1 = invoice0.dup
      invoice1.update(label: 'çé"à;ç\";,@\\', date: "2014-08-01", unique_index: 2, advance: 3.0, vat_rate: 20)
      invoice1.lines.create(quantity: 1, unit_price: 13.0)
      csv_output = ::Dorsale::BillingMachine::Invoice.to_csv

      expect(csv_output).to be ==
        columns_names +
        '"2014-07-31";"2014-01";"invoiceLabel";"cutomerName";"address1";"address2";'\
        '"13005";"Marseille";"country";"9,99";"19,60";"1,96";"11,95";"3,50";"8,45"' + "\n"\
        '"2014-08-01";"2014-02";"çé""à;ç\"";,@\";"cutomerName";"address1";"address2";'\
        '"13005";"Marseille";"country";"13,00";"20,00";"2,60";"15,60";"3,00";"12,60"' + "\n"
    end
    it 'should return expected csv with nil values' do
      invoice0 = create(:billing_machine_invoice, id_card: id_card, total_duty: nil,
        vat_rate: nil, vat_amount: nil, total_all_taxes: 0, advance: nil, label: nil,
        customer: nil, payment_term: nil)
      csv_output = ::Dorsale::BillingMachine::Invoice.to_csv

      expect(csv_output).to be ==
        columns_names +
        '"2014-02-19";"2014-01";"";"";"";"";"";"";"";"0,00";"0,00";"0,00";"0,00";"0,00";"0,00"' + "\n"
    end
  end
end
