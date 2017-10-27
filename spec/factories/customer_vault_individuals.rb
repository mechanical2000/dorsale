FactoryBot.define do
  factory :customer_vault_individual, class: ::Dorsale::CustomerVault::Individual do
    origin     { create(:customer_vault_origin)                      }
    first_name { Faker::Name.first_name                              }
    last_name  { Faker::Name.last_name                               }
    short_name { "SN"                                                }
    email      { Faker::Internet.email("#{first_name} #{last_name}") }
    title      { "Individual-Title"                                  }
    twitter    { "#{first_name}#{last_name}"                         }
    www        { Faker::Internet.url                                 }
    context    { "Individual-Context"                                }
    phone      { "01 23 xx xx xx"                                    }
    fax        { "09 xx xx xx xx"                                    }
    mobile     { "06 xx xx xx xx"                                    }

    after(:create) do |individual|
      create(:dorsale_address, addressable: individual)
    end
  end
end
