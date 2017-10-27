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

  it { is_expected.to belong_to :activity_type }
  it { is_expected.to belong_to :origin }

  it { is_expected.to respond_to :context }

  describe "activity type" do
    it "should have the same activity than his corporation" do
      corporation = create(:customer_vault_corporation)
      individual = create(:customer_vault_individual, corporation: corporation)
      expect(individual.activity_type).to eq corporation.activity_type
    end

    it "should have no activity if no corporation" do
      individual = create(:customer_vault_individual, corporation: nil)
      expect(individual.activity_type).to eq nil
    end

    it "should have no activity if his corporation has no activity" do
      corporation = create(:customer_vault_corporation, activity_type: nil)
      individual = create(:customer_vault_individual, corporation: corporation)
      expect(individual.activity_type).to eq nil
    end
  end
end
