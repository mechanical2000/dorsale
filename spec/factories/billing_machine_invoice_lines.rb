FactoryGirl.define do
  factory :billing_machine_invoice_line, class: ::Dorsale::BillingMachine::InvoiceLine do
    invoice    { create(:billing_machine_invoice) }

    label      { "Invoice line" + Faker::Lorem.words.join(" ") }
    quantity   { 10 }
    unit       { "€" }
    unit_price { 20 }
    vat_rate     { 20.0 }
    total      { 240 }
  end
end
