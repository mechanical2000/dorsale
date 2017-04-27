FactoryGirl.define do
  factory :customer_vault_corporation, class: ::Dorsale::CustomerVault::Corporation do
    activity_type { create(:customer_vault_activity_type)             }
    origin        { create(:customer_vault_origin)                    }
    name          { "#{Faker::Company.name} #{Faker::Company.suffix}" }
    short_name    { "SN"                                              }
    email         { Faker::Internet.email                             }
    phone         { "06 xx xx xx xx"                                  }
    fax           { "09 xx xx xx xx"                                  }
    www           { Faker::Internet.url                               }

    after(:create) do |corporation|
      create(:dorsale_address, addressable: corporation)
    end
  end
end
