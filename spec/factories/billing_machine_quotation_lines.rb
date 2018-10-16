FactoryBot.define do
  factory :billing_machine_quotation_line, class: ::Dorsale::BillingMachine::QuotationLine do
    quotation  { create(:billing_machine_quotation) }
    label      { "Quotation line" + Faker::Lorem.words.join(" ") }
    quantity   { 10 }
    unit       { "€" }
    unit_price { 20 }
  end
end
