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
  it { is_expected.to respond_to :commercial_discount }

  it "should have a valid factory" do
    expect(create(:billing_machine_quotation)).to be_valid
  end

  it "default date should be today" do
    expect(::Dorsale::BillingMachine::Quotation.new.date).to eq Date.today
  end

  it "default expires_at should be date + 1 month" do
    quotation = ::Dorsale::BillingMachine::Quotation.new(date: "21/12/2012")
    expect(quotation.expires_at).to eq Date.parse("21/01/2013")
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
      quotation = create(:billing_machine_quotation, vat_rate: 20, total_duty: 0, vat_amount: 0, total_all_taxes: 0, commercial_discount: 10)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      expect(quotation.total_duty).to eq(90.0)
      expect(quotation.vat_amount).to eq(18.0)
      expect(quotation.total_all_taxes).to eq(108.0)
    end
    it "should be calculated upon saving" do
      quotation = create(:billing_machine_quotation, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil, commercial_discount: 10.50)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)
      create(:billing_machine_quotation_line, quantity: 10, unit_price: 5, quotation: quotation)

      expect(quotation.total_duty).to eq(89.5)
      expect(quotation.vat_amount).to eq(0.0)
      expect(quotation.total_all_taxes).to eq(89.5)
    end

    it "should work fine even with empty lines" do
      quotation = create(:billing_machine_quotation, vat_rate: nil, total_duty: nil, vat_amount: nil, total_all_taxes: nil, commercial_discount: nil)
      create(:billing_machine_quotation_line, quantity: nil, unit_price: nil, quotation: quotation)
      expect(quotation.total_duty).to eq(0.0)
    end
  end

  describe "#create_copy!" do
    it "should duplicate infos, lines, and documents" do
      q  = create(:billing_machine_quotation, label: "ABC")
      ql = create(:billing_machine_quotation_line, quotation: q, label: "DEF")
      pdf = create(:alexandrie_attachment, attachable: q)

      q2 = q.create_copy!.reload
      expect(q2).to be_persisted
      expect(q2.label).to eq "ABC"
      expect(q2.lines.count).to eq 1
      expect(q2.lines.first.label).to eq "DEF"
      expect(q2.attachments.count).to eq 1
    end

    it "should reset date" do
      q = create(:billing_machine_quotation, date: 3.days.ago)
      expect(q.date).to_not eq Date.today
      expect(q.create_copy!.date).to eq Date.today
    end

    it "should reset unique_index, tracking_id, created_at, updated_at" do
      q1 = create(:billing_machine_quotation)
      q2 = q1.create_copy!.reload
      expect(q1.unique_index).to_not eq q2.unique_index
      expect(q1.tracking_id).to_not eq q2.tracking_id
      expect(q1.created_at).to_not eq q2.created_at
      expect(q1.updated_at).to_not eq q2.updated_at
    end

    xit "should reset state to pending" do
      # state not yet implemented
    end
  end

  describe "#create_invoice!" do
    it "should convert quotation to invoice" do
      q  = create(:billing_machine_quotation, label: "ABC")
      ql = create(:billing_machine_quotation_line, quotation: q, label: "DEF")

      i = q.create_invoice!.reload

      expect(i).to be_a Dorsale::BillingMachine::Invoice
      expect(i).to be_persisted
      expect(i.label).to eq "ABC"
      expect(i.lines.count).to eq 1
      expect(i.lines.first.label).to eq "DEF"
    end

    it "should reset date" do
      q = create(:billing_machine_quotation, date: 3.days.ago)
      expect(q.date).to_not eq Date.today
      expect(q.create_invoice!.date).to eq Date.today
    end

    it "should reset unique_index, tracking_id, created_at, updated_at" do
      q = create(:billing_machine_quotation, unique_index: 56544)
      i = q.create_invoice!.reload
      expect(i.unique_index).to_not eq q.unique_index
      expect(i.tracking_id).to_not eq q.tracking_id
      expect(i.created_at).to_not eq q.created_at
      expect(i.updated_at).to_not eq q.updated_at
    end
  end

end
