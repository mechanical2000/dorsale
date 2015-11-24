FactoryGirl.define do
  factory :billing_machine_quotation, class: ::Dorsale::BillingMachine::Quotation do
    customer     { create(:customer_vault_corporation) }
    payment_term { create(:billing_machine_payment_term) }
    id_card      { create(:billing_machine_id_card) }
    date         { "2014-02-19" }
    label        { "Software service" }
    comments     { "This is the quotation for the software your companie want" }
  end
end
