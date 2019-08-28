require "rails_helper"

describe Dorsale::BillingMachine::QuotationLine do
  it { is_expected.to belong_to :quotation }
  it { is_expected.to validate_presence_of :quotation }

  it { is_expected.to respond_to :quantity }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :vat_rate }
  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :unit }
  it { is_expected.to respond_to :unit_price }

  it "should have a valid factory" do
    expect(build(:billing_machine_quotation_line)).to be_valid
  end

  describe "default values" do
    it "quantity should be 0" do
      expect(described_class.new.quantity).to eq 0
    end

    it "unit_price should be 0" do
      expect(described_class.new.unit_price).to eq 0
    end

    it "vat_rate should be 0" do
      expect(described_class.new.vat_rate).to eq ::Dorsale::BillingMachine.default_vat_rate
    end
  end

  it "should be sorted by created_at" do
    line1 = create(:billing_machine_quotation_line, :created_at => Time.zone.now + 1.minute)
    line2 = create(:billing_machine_quotation_line, :created_at => Time.zone.now + 2.minutes)
    line3 = create(:billing_machine_quotation_line, :created_at => Time.zone.now + 3.minutes)
    line4 = create(:billing_machine_quotation_line, :created_at => Time.zone.now + 4.minutes)
    line3.update!(:created_at => Time.zone.now + 5.minutes)
    lines = described_class.all
    expect(lines).to eq [line1, line2, line4, line3]
  end

  it "should update the total upon save" do
    line = create(:billing_machine_quotation_line, quantity: 12.34, unit_price: 12.34, total: 0)
    expect(line.total.to_f).to eq 152.28
  end

  it "should update the total gracefully with invalid data" do
    line = create(:billing_machine_quotation_line, quantity: nil, unit_price: nil, total: 0)
    expect(line.total.to_f).to eq 0
  end
end
