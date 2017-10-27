FactoryBot.define do
  factory :alexandrie_attachment_type, class: ::Dorsale::Alexandrie::AttachmentType do
    name { Faker::Lorem.words.join(" ") }
  end
end
