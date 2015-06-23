FactoryGirl.define do
  factory :customer_vault_link, class: CustomerVault::Link do
    association :alice, factory: :customer_vault_individual
    association :bob,   factory: :customer_vault_corporation
    title "Manager"
  end
end
