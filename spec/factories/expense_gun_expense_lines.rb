FactoryBot.define do
  factory :expense_gun_expense_line, class: ::Dorsale::ExpenseGun::ExpenseLine do
    name            { Faker::Lorem.sentence(3)                 }
    category        { FactoryBot.create(:expense_gun_category) }
    date            { Faker::Date.backward(30)                 }
    total_all_taxes { rand(100..1000)                          }
    vat             { rand(1..(total_all_taxes/5))             }
    company_part    { [25, 50, 75, 100].sample                 }
  end
end
