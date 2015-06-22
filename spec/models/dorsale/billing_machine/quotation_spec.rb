require 'spec_helper'

describe Quotation do
  let(:id_card) {
    create(:id_card, entity: entity)
  }

  it 'should have a valid factory' do
    expect(create(:quotation)).to be_valid
  end

  it { should belong_to :customer }
  it { should belong_to :payment_term }

  it { should have_many :lines }

  it { should validate_presence_of :id_card }
  it { should validate_presence_of :date }

  it { should respond_to :date?}
  it { should respond_to :label?}
  it { should respond_to :total_duty?}
  it { should respond_to :vat_amount?}
  it { should respond_to :vat_rate?}
  it { should respond_to :total_all_taxes?}
  it { should respond_to :comments?}
  it { should respond_to :unique_index?}

  it 'should work fine upon creation' do
      quotation = FactoryGirl.build(:quotation)
      quotation.lines << QuotationLine.new(quantity: 1, unit_price: 10)
      quotation.lines << QuotationLine.new(quantity: 1, unit_price: 10)
      quotation.save
    end

  describe 'unique_index' do
    context ' when unique index is 69' do
      let(:entity) { FactoryGirl.create(:entity, unique_index: 69) }

      it 'should be assigned upon creation' do
        invoice = FactoryGirl.create(:invoice, id_card: id_card, date:'2014-02-01')
        invoice.unique_index.should eq(70)
        entity.reload.unique_index.should eq(70)
      end
    end
  end

  describe 'quotation_tracking_id' do
    it 'should return correct quotation_tracking_id for agilidee for first invoice' do
      entity = FactoryGirl.create(:entity, unique_index: nil, customization_prefix: 'agilidee')
      id_card = FactoryGirl.create(:id_card, entity: entity)
      quotation = FactoryGirl.create(:quotation, id_card: id_card, date: '2010-05-20')
      quotation.tracking_id.should eq('10052001')
    end
    it 'should return correct quotation_tracking_id for agilidee' do
      entity = FactoryGirl.create(:entity, unique_index: 36, quotation_index: 36, customization_prefix: 'agilidee')
      id_card = FactoryGirl.create(:id_card, entity: entity)
      quotation = FactoryGirl.create(:quotation, id_card: id_card, date: '2013-05-20')
      quotation.tracking_id.should eq('13052037')
    end
  end

  describe 'totals' do
    it 'should be calculated upon saving' do
      quotation = FactoryGirl.create(:quotation, vat_rate: 20, total_duty: 0, vat_amount: 0, total_all_taxes: 0)
      FactoryGirl.create(:quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      FactoryGirl.create(:quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      expect(quotation.total_duty).to eq(100.0)
      expect(quotation.vat_amount).to eq(20.0)
      expect(quotation.total_all_taxes).to eq(120.0)
    end
    it 'should be calculated upon saving' do
      quotation = FactoryGirl.create(:quotation, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil)
      FactoryGirl.create(:quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      FactoryGirl.create(:quotation_line, quantity: 10, unit_price: 5, quotation: quotation)

      expect(quotation.total_duty).to eq(100.0)
      expect(quotation.vat_amount).to eq(0.0)
      expect(quotation.total_all_taxes).to eq(100.0)
    end

    it 'should work fine even with empty lines' do
      quotation = FactoryGirl.create(:quotation, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil)
      FactoryGirl.create(:quotation_line, quantity: nil, unit_price: nil, quotation: quotation)
      expect(quotation.total_duty).to eq(0.0)
    end
  end
end
