FactoryGirl.define do
  factory :customer_vault_activity_type, class: ::Dorsale::CustomerVault::ActivityType do
    name { Faker::Lorem.word }
  end
end
