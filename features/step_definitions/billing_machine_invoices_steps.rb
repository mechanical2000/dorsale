Given(/^an existing emtpy invoice$/) do
  @invoice = create(:billing_machine_invoice, label: nil, customer: nil, payment_term_id: nil, id_card: @id_card)
  @invoice.due_date = nil
  @invoice.save
end

Given(/^(\d+) existing invoices$/) do |count|
  create_list(:billing_machine_invoice, count.to_i, id_card: @id_card)
end

Given(/^an existing invoice$/) do
  @invoice = create(:billing_machine_invoice, id_card: @id_card, customer: @customer)
  @invoice.lines.create(quantity: 1, unit_price: 9.99)
end

Given(/^an existing invoice with a "(.*?)"% VAT rate$/) do |rate|
  @invoice = create(:billing_machine_invoice, id_card: @id_card, vat_rate: rate)
end

Given(/^an existing paid invoice$/) do
  @invoice = create(:billing_machine_invoice, id_card: @id_card, paid: true)
end

When(/^(the user|he) goes to the invoices page$/) do |arg1|
  visit dorsale.billing_machine_invoices_path
end

When(/^he creates a new invoice$/) do
  find(".link_create").click
end

When(/^he fills the reference, the date and the payment terms$/) do
  fill_in 'invoice_label', with: @label = 'My reference'
  fill_in 'invoice_date', with: @date = '01/01/2014'
  select @payment_term.label
end

When(/^he chooses the customer$/) do
  select @customer.name
end

When(/^the user goes to the invoice details$/) do
  visit dorsale.billing_machine_invoice_path(@invoice)
end

When(/^wants to copy it$/) do
  find(".link_copy").click
end

Then(/^a new invoice is displayed with the informations$/) do
  expect(page).to have_field('invoice_label', with: @invoice.label)
end

Then(/^he can see all the informations$/) do
  expect(page).to have_selector '.invoice-label', @invoice.label
end

When(/^he fills a line with "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/) do |arg1, arg2, arg3, arg4|
  within(all('.invoice-line').last()) do
    find(:css,"input.line-label").set(arg1)
    find(:css,"input.line-quantity").set arg2
    find(:css,"input.line-unit").set arg3
    find(:css,"input.line-unit_price").set arg4
  end
end

Then(/^he should see (\d+) invoices$/) do |count|
  expect(page).to have_selector '.invoice', count: count
end

Then(/^the invoice is displayed correctly$/) do
  expect(page).to have_selector '.tracking_id', @invoice.tracking_id
end

Then(/^the new line's total should be "(.*?)"$/) do |arg1|
  expect(page).to have_selector '.line-total', text: arg1
end

When(/^he adds a new line$/) do
  click_link 'add-new-line'
end

Then(/^the total duty is "(.*?)"$/) do |arg1|
  expect(page).to have_selector '.total #invoice-total-duty', text: arg1
end

Then(/^the VAT due is "(.*?)"$/) do |arg1|
  expect(page).to have_selector '.total #invoice-vat_amount', text: arg1
end

Then(/^the total all taxes included is "(.*?)"$/) do |arg1|
  expect(page).to have_selector '.total #invoice-total-taxes', text: arg1
end

When(/^he saves the invoice$/) do
  find("[type=submit]").click
end

Then(/^it's added to the invoice list$/) do
  step('the user goes to the invoices page')
  expect(page).to have_selector '.invoice .date', text: @date
  # There are no other invoices for this test so we should get the right number
  tracking_id = ::Dorsale::BillingMachine::Invoice.first.tracking_id
  expect(page).to have_selector '.invoice .tracking_id', text: tracking_id
  expect(page).to have_selector '.invoice .customer_name', text: @customer.name
  expect(page).to have_selector '.invoice .total_duty', text: '200,00 €'
end

When(/^he goes on the edit page of the invoice$/) do
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
end

When(/^changes the label$/) do
  @new_label=  @invoice.label + " Edited"
  fill_in 'invoice_label', with: @new_label
end

Then(/^the invoices's label has changed$/) do
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
  expect(page).to have_field('invoice_label', with: @new_label)
end

Then(/^the VAT rate is "(.*?)"$/) do |rate|
  expect(page).to have_field('invoice_vat_rate', with: rate)
end

When(/^he changes the VAT rate to "(.*?)"$/) do |new_rate|
  fill_in 'invoice_vat_rate', with: new_rate
end

Then(/^the new line total is "(.*?)"$/) do |value|
  expect(page).to have_selector '.invoice-line .line-total', text: value
end

Then(/^the existing line total is "(.*?)"$/) do |value|
  expect(page).to have_selector '.invoice-line .line-total', text: value
end

When(/^he finds and clicks on the download CSV export file$/) do
  find("[href$=csv]").click
end

When(/^he set the invoice as paid$/) do
  find("[href$=pay]").click
end

Then(/^the invoice is marked paid$/) do
  expect(page).to have_selector '.paid'
end

Then(/^can't set the invoice as paid again$/) do
  expect(all("[href$=pay]").count).to eq 0
end

When(/^he marks the invoice as unpaid$/) do
  within '.form-group.select.invoice_paid' do
    select 'No'
  end
end

Then(/^the invoice is marked unpaid$/) do
  expect(page).to_not have_selector '.paid'
end

Then(/^the invoice status is set to unpaid$/) do
  expect(@invoice.reload.paid?).to be false
end

Then(/^the invoice status is set to paid$/) do
  expect(@invoice.reload.paid?).to be true
end

Then(/^a message signals the success of the update$/) do
  expect(find('.alert-success')).to be_visible
end

Then(/^a message signals the success of the creation$/) do
  expect(find('.alert-success')).to be_visible
end

Then(/^a message signals that the invoice is set to paid$/) do
  expect(find('.alert-success')).to be_visible
end

Then(/^the advance is "(.*?)"€$/) do |value|
  expect(page).to have_field('invoice_advance', with: value)
end

Then(/^the balance included is "(.*?)"$/) do |value|
  expect(page).to have_selector '#invoice-balance', text: value
end

When(/^he changes the advance to "(.*?)"€$/) do |value|
  fill_in 'invoice_advance', with: value
end

When(/^he goes to the newly created invoice page$/) do
  @invoice = ::Dorsale::BillingMachine::Invoice.unscoped.order(:id).last
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
end

Then(/^the invoice line shows the right date$/) do
  expect(page).to have_selector '.date' , text: I18n.l(@invoice.date)
end

Then(/^the invoice line shows the right traking-id$/) do
  expect(page).to have_selector '.invoice-tracking_id' , text: @invoice.tracking_id
end

Then(/^the invoice line shows the right total-duty value$/) do
  expect(page).to have_selector '.total-duty' , text: "9,99 €"
end

Then(/^the invoice line shows the right all taxes value$/) do
  expect(page).to have_selector '.all-taxes' , text: "11,99 €" #@invoice.total_all_taxes pb d'arrondi
end

Then(/^the invoice line shows the right customer's name$/) do
  expect(page).to have_selector '.customer-name', text: @customer.name
end

Then(/^the invoice default date is set to today's date\.$/) do
  expect(page).to have_field('invoice_date', with: I18n.l(Date.today))
end

Then(/^the invoice default due date is set to today's date\.$/) do
  expect(page).to have_field('invoice_due_date', with: I18n.l(Date.today + 30.days))
end
