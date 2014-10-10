# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dorsale_address, :class => 'Dorsale::Address' do
    street "3 Rue Marx Dormoy"
    street_bis ""
    city "Marseille"
    zip "13004"
    country "France"
  end
end
