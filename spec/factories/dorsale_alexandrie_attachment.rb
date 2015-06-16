FactoryGirl.define do
  factory :dorsale_alexandrie_attachment, class: Dorsale::Alexandrie::Attachment do
    attachable {
      DummyModel.create!(name: "abc")
    }

    file {
      path = Rails.root.join("../../spec/files/pdf.pdf").to_s
      Rack::Test::UploadedFile.new(path, "application/pdf")
    }
  end
end
