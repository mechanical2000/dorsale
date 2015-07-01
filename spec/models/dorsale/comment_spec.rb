require "rails_helper"


RSpec.describe Dorsale::Comment, type: :model do
  it { is_expected.to belong_to :commentable }
  it { is_expected.to validate_presence_of :commentable }

  it "should have a valid factory" do
    expect(create(:dorsale_comment)).to be_valid
  end
end
