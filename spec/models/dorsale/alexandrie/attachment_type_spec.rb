require "rails_helper"

describe ::Dorsale::Alexandrie::AttachmentType, type: :model do
  it { is_expected.to have_many(:attachments).dependent(:nullify) }

  it { is_expected.to validate_presence_of :name }

  it "factory should be valid" do
    expect(create(:alexandrie_attachment_type)).to be_valid
  end
end
