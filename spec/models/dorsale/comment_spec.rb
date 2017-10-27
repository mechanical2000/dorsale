require "rails_helper"

RSpec.describe Dorsale::Comment, type: :model do
  it { is_expected.to belong_to :author }
  it { is_expected.to validate_presence_of :author }

  it { is_expected.to belong_to :commentable }
  it { is_expected.to validate_presence_of :commentable }

  it { is_expected.to validate_presence_of :date }
  it { is_expected.to_not validate_presence_of :title }

  describe "factories" do
    it "should have a valid factory" do
      expect(create(:dorsale_comment)).to be_valid
    end
  end # describe "factories"

  describe "default values" do
    it "should set date" do
      expect(described_class.new.date).to be_present
    end
  end # describe "default values"
end
