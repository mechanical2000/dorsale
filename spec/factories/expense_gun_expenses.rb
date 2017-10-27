FactoryBot.define do
  factory :expense_gun_expense, class: ::Dorsale::ExpenseGun::Expense do
    name { Faker::Lorem.sentence(3) }
    date { Date.current             }
    user { create(:user)            }

    after(:create) { |expense|
      rand(2..5).times {
        create(:expense_gun_expense_line, expense: expense)
      }
    }
  end
end
