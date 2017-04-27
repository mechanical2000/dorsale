RSpec.describe ::Dorsale::CustomerVault::ActivityType, type: :model do
  it { is_expected.to validate_presence_of :name }

  it "should have a valid factory" do
    activity_type = create(:customer_vault_activity_type)
    expect(activity_type).to be_valid
  end
end
