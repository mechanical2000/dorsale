FactoryBot.define do
  factory :customer_vault_origin, class: ::Dorsale::CustomerVault::Origin do
    name { Faker::Lorem.word }
  end
end
