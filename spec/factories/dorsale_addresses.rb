FactoryBot.define do
  factory :dorsale_address, class: ::Dorsale::Address do
    street     { "3 Rue Marx Dormoy" }
    street_bis { "1er étage" }
    city       { "Marseille" }
    zip        { "13004" }
    country    { "France" }
  end
end
