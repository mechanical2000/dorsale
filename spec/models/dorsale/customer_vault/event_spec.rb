require 'rails_helper'

RSpec.describe ::Dorsale::CustomerVault::Event, type: :model do
  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :person }
  it { is_expected.to belong_to :comment }

  it { is_expected.to validate_presence_of :person }
  it { is_expected.to validate_presence_of :action }

  it { is_expected.to_not validate_presence_of :author }
  it { is_expected.to_not validate_presence_of :comment }

  it "should validate comment if action is comment" do
    event = described_class.new(action: "comment")
    expect(event).to validate_presence_of :comment
  end

  it "should have a valid factory" do
    event = create(:customer_vault_event)
    expect(event).to be_valid
  end
end
