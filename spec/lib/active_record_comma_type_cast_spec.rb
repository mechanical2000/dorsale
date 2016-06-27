require "rails_helper"

describe ActiveRecordCommaTypeCast, type: :model do
  let(:line) { FactoryGirl.create(:billing_machine_invoice_line) }

  it "should accept , as decimal separator" do
    line.update_attributes!(quantity: "12,34")
    expect(line.reload.quantity).to eq 12.34
  end

  it "should accept . as decimal separator" do
    line.update_attributes!(quantity: "12.34")
    expect(line.reload.quantity).to eq 12.34
  end

  it "should accept space as group separator" do
    line.update_attributes!(quantity: "123 456,78")
    expect(line.reload.quantity).to eq 123456.78

    line.update_attributes!(quantity: "123 456.78")
    expect(line.reload.quantity).to eq 123456.78
  end

  it "should accept nbsp as group separator" do
    line.update_attributes!(quantity: "123 456,78")
    expect(line.reload.quantity).to eq 123456.78

    line.update_attributes!(quantity: "123 456.78")
    expect(line.reload.quantity).to eq 123456.78
  end

  it "should accept negative numbers" do
    line.update_attributes!(quantity: "-12,34")
    expect(line.reload.quantity).to eq -12.34

    line.update_attributes!(quantity: "-12.34")
    expect(line.reload.quantity).to eq -12.34
  end

  it "should accept trailing chars" do
    line.update_attributes!(quantity: "abc 12.34 def")
    expect(line.reload.quantity).to eq 12.34
  end
end
