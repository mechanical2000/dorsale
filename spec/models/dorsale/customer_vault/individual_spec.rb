require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Individual, :type => :model do
  it "should have a valid factory" do
    individual = build(:customer_vault_individual)
    expect(individual).to be_valid
  end

  it { is_expected.to have_one(:address).dependent(:destroy) }
  it { is_expected.to belong_to :corporation }
  it { is_expected.to have_many :comments }
  it { is_expected.to have_many :taggings }
  it { is_expected.to have_many :tags }
  it { is_expected.to have_many(:tasks).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:events).dependent(:destroy) }
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }

  it { is_expected.to respond_to :context }
end
