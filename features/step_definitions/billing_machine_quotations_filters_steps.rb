Given(/^a bunch of existing quotations$/) do
  c1 = create(:billing_machine_corporation, name: 'Bidule')
  c2 = create(:billing_machine_corporation, name: 'Machin')
  c3 = create(:billing_machine_corporation, name: 'Chose')

  i1 = create(:billing_machine_individual, first_name: 'Oh')
  i2 = create(:billing_machine_individual, first_name: 'Ah')
  i3 = create(:billing_machine_individual, first_name: 'Eh')

  create(:billing_machine_quotation, id_card: @id_card, customer: c1, date: Date.today)
  create(:billing_machine_quotation, id_card: @id_card, customer: c2, date: Date.today)
  create(:billing_machine_quotation, id_card: @id_card, customer: c3, date: Date.today)
  create(:billing_machine_quotation, id_card: @id_card, customer: c1, date: Date.today - 2.days)

  create(:billing_machine_quotation, id_card: @id_card, customer: i1, date: Date.today - 3.days)
  create(:billing_machine_quotation, id_card: @id_card, customer: i2, date: Date.today - 3.days)
  create(:billing_machine_quotation, id_card: @id_card, customer: i3, date: Date.today - 3.days)
end

Then(/^only the quotations of this customer do appear$/) do
  expect(page).to have_selector(".customer-name", text: 'Bidule', count: 2)
end

Then(/^only the quotations of today do appear$/) do
  expect(page).to have_selector(".quotation", count: 3)
end
