data = [
  [
    Dorsale::BillingMachine::Invoice.t(:date),
    Dorsale::BillingMachine::Invoice.t(:tracking_id),
    Dorsale::BillingMachine::Invoice.t(:label),
    Dorsale::CustomerVault::Person.t(:name),
    Dorsale::CustomerVault::Person.t(:street),
    Dorsale::CustomerVault::Person.t(:street_bis),
    Dorsale::CustomerVault::Person.t(:zip),
    Dorsale::CustomerVault::Person.t(:city),
    Dorsale::CustomerVault::Person.t(:country),
    Dorsale::BillingMachine::Invoice.t(:commercial_discount),
    Dorsale::BillingMachine::Invoice.t(:total_excluding_taxes),
    Dorsale::BillingMachine::Invoice.t(:vat_amount),
    Dorsale::BillingMachine::Invoice.t(:total_including_taxes),
    Dorsale::BillingMachine::Invoice.t(:advance),
    Dorsale::BillingMachine::Invoice.t(:balance),
  ],
]

@invoices_without_pagination.each do |invoice|
  data << [
    invoice.date,
    invoice.tracking_id,
    invoice.label,
    invoice.customer.try(:name),
    invoice.customer.try(:address).try(:street),
    invoice.customer.try(:address).try(:street_bis),
    invoice.customer.try(:address).try(:zip),
    invoice.customer.try(:address).try(:city),
    invoice.customer.try(:address).try(:country),
    invoice.commercial_discount,
    invoice.total_excluding_taxes,
    invoice.vat_amount,
    invoice.total_including_taxes,
    invoice.advance,
    invoice.balance,
  ]
end

Agilibox::Serializers::XLSX.new(data).render_inline
