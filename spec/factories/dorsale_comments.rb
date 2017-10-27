FactoryBot.define do
  factory :dorsale_comment, class: ::Dorsale::Comment do
    commentable { create(:customer_vault_corporation) }
    author      { create(:user)                       }
    text        { Faker::Lorem.paragraph              }
  end
end
