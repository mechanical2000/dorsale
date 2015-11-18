FactoryGirl.define do
  factory :billing_machine_invoice, class: ::Dorsale::BillingMachine::Invoice do
    customer     { create(:customer_vault_corporation) }
    payment_term { create(:billing_machine_payment_term) }
    id_card      { create(:billing_machine_id_card) }
    date         { "2014-02-19" }
    label        { "Software service" }
    advance      { 0 }
  end
end
