require "rails_helper"

describe ::Dorsale::BillingMachine::Quotation do
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :payment_term }

  it { is_expected.to have_many :lines }

  it { is_expected.to validate_presence_of :id_card }
  it { is_expected.to validate_presence_of :date }

  it { is_expected.to respond_to :date }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :total_duty }
  it { is_expected.to respond_to :vat_amount }
  it { is_expected.to respond_to :vat_rate }
  it { is_expected.to respond_to :total_all_taxes }
  it { is_expected.to respond_to :comments }
  it { is_expected.to respond_to :unique_index }

  it "should have a valid factory" do
    expect(create(:billing_machine_quotation)).to be_valid
  end

  it "should work fine upon creation" do
      quotation = build(:billing_machine_quotation)
      quotation.lines << ::Dorsale::BillingMachine::QuotationLine.new(quantity: 1, unit_price: 10)
      quotation.lines << ::Dorsale::BillingMachine::QuotationLine.new(quantity: 1, unit_price: 10)
      quotation.save
    end

  describe 'unique_index' do
    context 'when unique index is 69' do
      it 'should be assigned upon creation' do
        quotation1 = create(:billing_machine_quotation, date: '2014-02-01', unique_index: 69)
        quotation2 = create(:billing_machine_quotation, date: '2014-02-01')
        expect(quotation2.unique_index).to eq(70)
      end
    end

    context 'when unique index is nil' do
      it 'should be assigned upon creation' do
        ::Dorsale::BillingMachine::Quotation.destroy_all
        quotation1 = create(:billing_machine_quotation, date: '2014-02-01')
        expect(quotation1.unique_index).to eq(1)
      end
    end
  end

  describe 'tracking_id' do
    it 'should return correct tracking_id' do
      quotation = create(:billing_machine_quotation, date: '2014-02-01')
      expect(quotation.tracking_id).to eq('2014-01')
    end
  end

  describe "totals" do
    it "should be calculated upon saving" do
      quotation = create(:billing_machine_quotation, vat_rate: 20, total_duty: 0, vat_amount: 0, total_all_taxes: 0)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      expect(quotation.total_duty).to eq(100.0)
      expect(quotation.vat_amount).to eq(20.0)
      expect(quotation.total_all_taxes).to eq(120.0)
    end
    it "should be calculated upon saving" do
      quotation = create(:billing_machine_quotation, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)

      expect(quotation.total_duty).to eq(100.0)
      expect(quotation.vat_amount).to eq(0.0)
      expect(quotation.total_all_taxes).to eq(100.0)
    end

    it "should work fine even with empty lines" do
      quotation = create(:billing_machine_quotation, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil)
      create(:billing_machine_quotation_line, quantity: nil, unit_price: nil, quotation: quotation)
      expect(quotation.total_duty).to eq(0.0)
    end
  end
end
