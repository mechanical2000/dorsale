FactoryGirl.define do
  factory :billing_machine_payment_term, class: ::Dorsale::BillingMachine::PaymentTerm do
    label { "Payment term " + Faker::Lorem.words.join(" ") }
  end
end
