FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password 'motdepasse'
    password_confirmation 'motdepasse'
  end
end
