RSpec.describe ::Dorsale::CustomerVault::Origin, type: :model do
  it { is_expected.to validate_presence_of :name }

  it "should have a valid factory" do
    origin = create(:customer_vault_origin)
    expect(origin).to be_valid
  end
end
