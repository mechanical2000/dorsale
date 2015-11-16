require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceLine, type: :model do
  it { is_expected.to belong_to :invoice }

  it { is_expected.to respond_to :quantity }
  it { is_expected.to respond_to :label }
  it { is_expected.to respond_to :vat_rate }
  it { is_expected.to respond_to :total }
  it { is_expected.to respond_to :unit }
  it { is_expected.to respond_to :unit_price }

  it "should have a valid factory" do
    expect(build(:billing_machine_invoice_line)).to be_valid
  end

  it "should be sorted by created_at" do
    line1 = create(:billing_machine_invoice_line, :created_at => DateTime.now + 1.seconds)
    line2 = create(:billing_machine_invoice_line, :created_at => DateTime.now + 2.seconds)
    line3 = create(:billing_machine_invoice_line, :created_at => DateTime.now + 3.seconds)
    line4 = create(:billing_machine_invoice_line, :created_at => DateTime.now + 4.seconds)
    line3.update(:created_at => DateTime.now+5.seconds)

    lines = ::Dorsale::BillingMachine::InvoiceLine.all
    expect(lines).to eq [line1, line2, line4, line3]
  end

  it "should update the total upon save" do
    invoice = create(:billing_machine_invoice_line, quantity: 10, unit_price: 10, total: 0)
    expect(invoice.total).to eq(100)
  end

  it "should update the total gracefully with invalid data" do
    invoice = create(:billing_machine_invoice_line, quantity: nil, unit_price: nil, total: 0)
    expect(invoice.total).to eq(0)
  end

  it "should accept , and . as decimal separator" do
    line = FactoryGirl.create(:billing_machine_invoice_line)

    line.update_attributes!(quantity: "12,34")
    expect(line.reload.quantity).to eq 12.34

    line.update_attributes!(quantity: "12.34")
    expect(line.reload.quantity).to eq 12.34

    line.update_attributes!(quantity: "123 456,78")
    expect(line.reload.quantity).to eq 123456.78

    line.update_attributes!(quantity: "123 456.78")
    expect(line.reload.quantity).to eq 123456.78

    line.update_attributes!(unit_price: "12,34")
    expect(line.reload.unit_price).to eq 12.34

  end
end
