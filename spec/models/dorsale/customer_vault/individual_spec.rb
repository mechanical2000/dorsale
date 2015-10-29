require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Individual, :type => :model do
  it "should have a valid factory" do
    individual = build(:customer_vault_individual)
    expect(individual).to be_valid
  end

  it { should have_one(:address).dependent(:destroy) }
  it { should have_many :comments }
  it { should have_many :taggings }
  it { should have_many :tags }
  it { should have_many(:tasks).dependent(:destroy) }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
end
