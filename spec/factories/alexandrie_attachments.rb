FactoryGirl.define do
  factory :alexandrie_attachment, class: ::Dorsale::Alexandrie::Attachment do
    attachable {
      DummyModel.create!(name: "abc")
    }

    file {
      path = Rails.root.join("../../spec/files/pdf.pdf").to_s
      Rack::Test::UploadedFile.new(path, "application/pdf")
    }
  end
end
