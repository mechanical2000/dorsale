FactoryBot.define do
  factory :expense_gun_category, class: ::Dorsale::ExpenseGun::Category do
    name           { Faker::Lorem.word       }
    code           { Faker::Number.number(4) }
    vat_deductible { [true, false].sample    }
  end
end
