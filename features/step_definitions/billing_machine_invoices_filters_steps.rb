#encoding: utf-8

Given(/^a bunch of existing invoices$/) do
  c1 = create(:customer_vault_corporation, name: 'Bidule')
  c2 = create(:customer_vault_corporation, name: 'Machin')
  c3 = create(:customer_vault_corporation, name: 'Chose')

  i1 = create(:customer_vault_individual, first_name: 'Oh')
  i2 = create(:customer_vault_individual, first_name: 'Ah')
  i3 = create(:customer_vault_individual, first_name: 'Eh')

  create(:billing_machine_invoice, id_card: @id_card, customer: c1, date: Date.today, paid: true)
  create(:billing_machine_invoice, id_card: @id_card, customer: c2, date: Date.today)
  create(:billing_machine_invoice, id_card: @id_card, customer: c3, date: Date.today)
  create(:billing_machine_invoice, id_card: @id_card, customer: c1, date: Date.today - 2.days)

  create(:billing_machine_invoice, id_card: @id_card, customer: i1, date: Date.today - 3.days)
  create(:billing_machine_invoice, id_card: @id_card, customer: i2, date: Date.today - 3.days)
  create(:billing_machine_invoice, id_card: @id_card, customer: i3, date: Date.today - 3.days)
end

When(/^he filters by one customer$/) do
  within('.filters') do
    select('Bidule')
    find(".filter-submit").click
  end
end

Then(/^only the invoices of this customer do appear$/) do
  expect(page).to have_selector(".customer-name", text: 'Bidule', count: 2)
end

Then(/^only the invoices of today do appear$/) do
  expect(page).to have_selector(".invoice", count: 3)
end

When(/^he filters by status on paid$/) do
  within('.filters') do
    select('Payées')
    find(".filter-submit").click
  end
end

Then(/^only the invoices paid do appear$/) do
  expect(page).to have_selector(".invoice", count: 1)
end
