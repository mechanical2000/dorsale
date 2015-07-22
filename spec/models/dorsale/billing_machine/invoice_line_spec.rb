require "rails_helper"

describe ::Dorsale::BillingMachine::InvoiceLine, type: :model do
  it { is_expected.to belong_to :invoice }

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
    business = FactoryGirl.create(:billing_machine_invoice_line)

    business.update_attributes!(quantity: "12,34")
    expect(business.reload.quantity).to eq 12.34

    business.update_attributes!(quantity: "12.34")
    expect(business.reload.quantity).to eq 12.34

    business.update_attributes!(quantity: "123 456,78")
    expect(business.reload.quantity).to eq 123456.78

    business.update_attributes!(quantity: "123 456.78")
    expect(business.reload.quantity).to eq 123456.78

    business.update_attributes!(unit_price: "12,34")
    expect(business.reload.unit_price).to eq 12.34

  end
end
