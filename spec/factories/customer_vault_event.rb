FactoryGirl.define do
  factory :customer_vault_event, class: ::Dorsale::CustomerVault::Event do
    author { build(:user)                       }
    person { build(:customer_vault_corporation) }
    action { "create"                           }
  end
end
