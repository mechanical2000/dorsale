require "rails_helper"

describe ::Dorsale::BillingMachine::IdCard do
  it "should have a valid factory" do
    expect(build(:billing_machine_id_card)).to be_valid
  end

  it { is_expected.to have_many :invoices }

  it { is_expected.to respond_to :logo }
end
