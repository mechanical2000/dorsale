require "rails_helper"

describe ::Dorsale::Alexandrie::Attachment, type: :model do
  it { is_expected.to belong_to :attachable }
  it { is_expected.to belong_to :sender }
  it { is_expected.to belong_to :attachment_type }

  it { is_expected.to validate_presence_of :attachable }
  it { is_expected.to validate_presence_of :file }

  it { is_expected.to_not validate_presence_of :attachment_type }
  it { is_expected.to_not validate_presence_of :sender }

  it "factory should be valid" do
    expect(create(:alexandrie_attachment)).to be_valid
  end

  it "should assign default name" do
    attachment = create(:alexandrie_attachment, name: nil)
    expect(attachment.name).to eq "pdf.pdf"
  end

  it "download_filename should be valid" do
    attachment = create(:alexandrie_attachment)
    expect(attachment.download_filename).to eq "pdf.pdf"

    attachment = create(:alexandrie_attachment, name: "hello")
    expect(attachment.download_filename).to eq "hello.pdf"

    attachment = create(:alexandrie_attachment, name: "hello.pdf")
    expect(attachment.download_filename).to eq "hello.pdf"

    attachment = create(:alexandrie_attachment, name: "hello.xls")
    expect(attachment.download_filename).to eq "hello-xls.pdf"
  end
end
