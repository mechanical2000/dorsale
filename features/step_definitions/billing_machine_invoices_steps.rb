Given(/^an existing emtpy invoice$/) do
  @invoice = create(:billing_machine_invoice, label: nil, customer: nil, payment_term_id: nil)
  @invoice.due_date = nil
  @invoice.save
end

Given(/^(\d+) existing invoices$/) do |count|
  create_list(:billing_machine_invoice, count.to_i)
end

Given(/^an existing invoice$/) do
  @invoice = create(:billing_machine_invoice, customer: @customer)
  @invoice.lines.create(quantity: 1, unit_price: 9.99)
end

Given(/^an existing invoice with a "(.*?)"% VAT rate$/) do |rate|
  @invoice = create(:billing_machine_invoice)
  create(:billing_machine_invoice_line, vat_rate: rate, invoice: @invoice)
end

Given(/^an existing paid invoice$/) do
  @invoice = create(:billing_machine_invoice, paid: true)
end

Given(/^billing machine in single vat mode$/) do
  ::Dorsale::BillingMachine.vat_mode = :single
end

Given(/^a bunch of existing invoices$/) do
  c1 = create(:customer_vault_corporation, name: "Bidule")
  c2 = create(:customer_vault_corporation, name: "Machin")
  c3 = create(:customer_vault_corporation, name: "Chose")

  i1 = create(:customer_vault_individual, first_name: "Oh")
  i2 = create(:customer_vault_individual, first_name: "Ah")
  i3 = create(:customer_vault_individual, first_name: "Eh")

  create(:billing_machine_invoice, customer: c1, date: Date.current, paid: true)
  create(:billing_machine_invoice, customer: c2, date: Date.current)
  create(:billing_machine_invoice, customer: c3, date: Date.current)
  create(:billing_machine_invoice, customer: c1, date: Date.current - 2.days)

  create(:billing_machine_invoice, customer: i1, date: Date.current - 3.days)
  create(:billing_machine_invoice, customer: i2, date: Date.current - 3.days)
  create(:billing_machine_invoice, customer: i3, date: Date.current - 3.days)
end

Given(/^an existing unpaid invoice$/) do
  @invoice = create(:billing_machine_invoice, paid: false)
end

Given(/^its due date is not yet passed$/) do
  @invoice.update!(due_date: (Date.current + 1))
end

Given(/^its due date is the same day$/) do
  @invoice.update!(due_date: Date.current)
end

Given(/^its due date is yesterday$$/) do
  @invoice.update!(due_date: (Date.current - 1))
end

Given(/^its due date is (\d+) days ago$/) do |days|
  @invoice.update!(due_date: (Date.current - days.to_i))
end

Given(/^existing "(.*?)" invoices with "(.*?)" amount$/) do |n, amount|
  n.to_i.times do
    create(:billing_machine_invoice_line, quantity: 1, unit_price: amount)
  end
end

When(/^(?:the user|he) goes to the invoices page$/) do
  visit dorsale.billing_machine_invoices_path
end

When(/^he creates a new invoice$/) do
  find(".link_create").click
end

When(/^he fills the reference, the date, the vat rate and the payment terms$/) do
  fill_in "invoice_label", with: @label = "My reference"
  fill_in "invoice_date", with: @date = "01/01/2014"
  fill_in "invoice_vat_rate", with: "20"
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

When(/^he fills a line with "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/) do |label, quantity, unit, unit_price|
  expect(page).to have_selector(".line")

  within all(".line").last do
    find(".line-label textarea").set label
    find(".line-quantity input").set quantity
    find(".line-unit input").set unit
    find(".line-unit_price input").set unit_price
  end
end

When(/^he goes on the edit page of the invoice$/) do
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
end

When(/^changes the label$/) do
  @new_label=  @invoice.label + " Edited"
  fill_in "invoice_label", with: @new_label
end

When(/^he changes the VAT rate to "(.*?)"$/) do |new_rate|
  fill_in "invoice_vat_rate", with: new_rate
end

When(/^he changes the commercial discount to "(.*?)"€$/) do |arg1|
  fill_in "invoice_commercial_discount", with: arg1
end

When(/^he adds a new line$/) do
  click_link "add-new-line"
end

When(/^he saves the invoice$/) do
  find("[type=submit]").click
end

When(/^he set the invoice as paid$/) do
  find("[href$=pay]").click
end

When(/^he marks the invoice as unpaid$/) do
  within ".form-group.select.invoice_paid" do
    select "No"
  end
end

When(/^he changes the advance to "(.*?)"€$/) do |value|
  fill_in "invoice_advance", with: value
end

When(/^he goes to the newly created invoice page$/) do
  @invoice = ::Dorsale::BillingMachine::Invoice.last_created
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
end

When(/^he filters by date on today$/) do
  select "Aujourd'hui"
  find(".filter-submit").click
end

When(/^he filters by one customer$/) do
  within(".filters") do
    select("Bidule")
    find(".filter-submit").click
  end
end

When(/^he filters by status on paid$/) do
  within(".filters") do
    select("Payée")
    find(".filter-submit").click
  end
end

When(/^the user download the pdf$/) do
  visit dorsale.billing_machine_invoice_path(@invoice)
  find(".link_download").click
end

Then(/^he should see (\d+) invoices?$/) do |count|
  expect(page).to have_selector ".invoice", count: count
end

Then(/^the invoice is displayed correctly$/) do
  expect(page).to have_selector ".tracking_id", @invoice.tracking_id
end

Then(/^the total excluding taxes is "(.*?)"$/) do |total|
  expect(find(".total_excluding_taxes input").value).to eq total
end

Then(/^the VAT due is "(.*?)"$/) do |vat|
  expect(find(".vat_amount input").value).to eq vat
end

Then(/^the total including taxes is "(.*?)"$/) do |total|
  expect(find(".total_including_taxes input").value).to eq total
end

Then(/^he fill the commercial discount with "(.*?)"$/) do |value|
  find(".commercial_discount input").set value
end

Then(/^it's added to the invoice list$/) do
  step("the user goes to the invoices page")
  expect(page).to have_selector ".invoice .date", text: @date
  # There are no other invoices for this test so we should get the right number
  tracking_id = ::Dorsale::BillingMachine::Invoice.first.tracking_id
  expect(page).to have_selector ".invoice .tracking_id", text: tracking_id
  expect(page).to have_selector ".invoice .customer_name", text: @customer.name
  expect(page).to have_selector ".invoice .total_excluding_taxes", text: "180,00 €"
end

Then(/^the commercial discount is "(.*?)"€$/) do |discount|
  expect(find(".commercial_discount input").value).to eq discount
end

Then(/^the invoices's label has changed$/) do
  visit dorsale.edit_billing_machine_invoice_path(@invoice)
  expect(page).to have_field("invoice_label", with: @new_label)
end

Then(/^the VAT rate is "(.*?)"$/) do |rate|
  expect(find(".vat_rate input").value).to eq rate
end

Then(/^the new line total is "(.*?)"$/) do |value|
  within all(".line").last do
    expect(find(".line-total input").value).to eq value
  end
end

Then(/^the invoice is marked paid$/) do
  expect(page).to have_selector ".paid"
end

Then(/^can't set the invoice as paid again$/) do
  expect(page).to_not have_selector("[href$=pay]")
end

Then(/^the invoice is marked unpaid$/) do
  expect(page).to_not have_selector ".paid"
end

Then(/^the invoice status is set to unpaid$/) do
  expect(@invoice.reload.paid?).to be false
end

Then(/^the invoice status is set to paid$/) do
  expect(@invoice.reload.paid?).to be true
end

Then(/^a message signals the success of the update$/) do
  expect(find(".alert-success")).to be_visible
end

Then(/^a message signals the success of the creation$/) do
  expect(find(".alert-success")).to be_visible
end

Then(/^a message signals that the invoice is set to paid$/) do
  expect(find(".alert-success")).to be_visible
end

Then(/^the advance is "(.*?)"€$/) do |advance|
  expect(find(".advance input").value).to eq advance
end

Then(/^the balance is "(.*?)"$/) do |balance|
  expect(find(".balance input").value).to eq balance
end

Then(/^the invoice line shows the right date$/) do
  expect(page).to have_selector ".date", text: I18n.l(@invoice.date)
end

Then(/^the invoice line shows the right traking-id$/) do
  expect(page).to have_selector ".tracking_id", text: @invoice.tracking_id
end

Then(/^the invoice line shows the right total excluding taxes value$/) do
  expect(page).to have_selector ".total_excluding_taxes", text: "9,99 €"
end

Then(/^the invoice line shows the right total including taxes value$/) do
  expect(page).to have_selector ".total_including_taxes", text: "11,99 €"
end

Then(/^the invoice line shows the right customer's name$/) do
  expect(page).to have_selector ".customer_name", text: @customer.name
end

Then(/^the invoice default date is set to today's date\.$/) do
  expect(page).to have_field("invoice_date", with: I18n.l(Date.current))
end

Then(/^the invoice default due date is set to today's date\.$/) do
  expect(page).to have_field("invoice_due_date", with: I18n.l(Date.current + 30.days))
end

Then(/^a new invoice is displayed with the informations$/) do
  expect(page).to have_field("invoice_label", with: @invoice.label)
end

Then(/^he can see all the informations$/) do
  expect(page).to have_selector ".invoice-label", @invoice.label
end

Then(/^only the invoices of this customer do appear$/) do
  expect(page).to have_selector(".customer_name", text: "Bidule", count: 2)
end

Then(/^only the invoices of today do appear$/) do
  expect(page).to have_selector(".invoice", count: 3)
end

Then(/^only the invoices paid do appear$/) do
  expect(page).to have_selector(".invoice", count: 1)
end

Then(/^the invoice paid status should not have a color$/) do
  expect(find(".invoice")[:class]).to_not include("paid", "late", "onalert")
end

Then(/^the invoice status should be "(.*?)"$/) do |color|
  expect(find(".invoice")[:class]).to include(color)
end

Then(/^data total amount is "(.*?)"$/) do |text|
  expect(page).to have_content text
end

When(/^he send invoice to customer by email$/) do
  ActionMailer::Base.deliveries.clear

  Dorsale::BillingMachine::PdfFileGenerator.(@invoice)
  @invoice.customer = create(:customer_vault_corporation, email: "aaa@example.org")
  @invoice.save!

  find("[href$=email]").click
  fill_in :email_subject, with: "abc"
  fill_in :email_body, with: "def"
  find("[type=submit]").click
end

Then(/^an invoice is sent to customer$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 1
  email = ActionMailer::Base.deliveries.first

  expect(email.to).to include "aaa@example.org"
  expect(email.subject).to eq "abc"
  expect(email.parts.first.body).to eq "def"
  expect(email.attachments.count).to eq 1
end

When(/^he filters invoices between two date$/) do
  fill_in :filters_bm_date_begin, with: I18n.l(Date.current)
  fill_in :filters_bm_date_end,   with: I18n.l(Date.current)
  find(".filter-submit").click
end

When(/^he click on the preview invoice button$/) do
  @invoices_count = Dorsale::BillingMachine::Invoice.count
  controller = Dorsale::BillingMachine::InvoicesController
  expect_any_instance_of(controller).to receive(:preview).and_call_original
  expect_any_instance_of(controller).to_not receive(:create)
  expect_any_instance_of(controller).to_not receive(:update)
  find("#preview-button").click
end

Then(/^he see the invoice preview$/) do
  expect(windows.count).to eq 2
end

Then(/^no invoice is created$/) do
  expect(Dorsale::BillingMachine::Invoice.count).to eq @invoices_count
end
