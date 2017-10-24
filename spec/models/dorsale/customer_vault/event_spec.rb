require 'rails_helper'

RSpec.describe ::Dorsale::CustomerVault::Event, type: :model do
  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :person }

  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :action }
  it { is_expected.to validate_presence_of :contact_type }

  it { is_expected.to_not validate_presence_of :author }

  it "should have a valid factory" do
    event = create(:customer_vault_event)
    expect(event).to be_valid
  end

  it "should assign default values" do
    expect(described_class.new.date).to be_present
    expect(described_class.new.contact_type).to eq "contact"
  end
end
