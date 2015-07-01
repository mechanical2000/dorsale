require "rails_helper"

describe ::Dorsale::Alexandrie::Attachment, type: :model do
  it { is_expected.to belong_to :attachable }

  it { is_expected.to validate_presence_of :attachable }
  it { is_expected.to validate_presence_of :file }

  it "factory should be valid" do
    expect(create(:alexandrie_attachment)).to be_valid
  end
end
