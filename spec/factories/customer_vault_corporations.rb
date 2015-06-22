FactoryGirl.define do
  factory :customer_vault_corporation, class: CustomerVault::Corporation do
    name  { "#{Faker::Company.name} #{Faker::Company.suffix}" }
    email { Faker::Internet.email                             }
    phone { "06 xx xx xx xx"                                  }
    fax   { "09 xx xx xx xx"                                  }
    www   { Faker::Internet.url                               }

    after(:create) do |corporation|
      create(:dorsale_address, addressable: corporation)
    end
  end
end
