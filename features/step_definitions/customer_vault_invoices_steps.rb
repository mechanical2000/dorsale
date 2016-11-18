Given(/^this (?:corporation|individual|person) has an invoice$/) do
 @invoice = create(:billing_machine_invoice, customer: @person)
end

When(/^he go on he (?:corporation|individual|person) invoices page$/) do
  visit dorsale.invoices_customer_vault_person_path(@person)
end
