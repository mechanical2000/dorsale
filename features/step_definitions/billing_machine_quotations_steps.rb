Given(/^an existing quotation$/) do
  @quotation = create(:billing_machine_quotation, customer: @customer)
  @quotation.lines.create(quantity: 1, unit_price: 9.99)
end

Given(/^(\d+) existing quotations$/) do |nb|
  create_list(:billing_machine_quotation, nb.to_i)
end

Given(/^an existing emtpy quotation$/) do
  @quotation = create(:billing_machine_quotation, label: nil, customer: nil)
end

Given(/^an existing quotation with a "(.*?)"% VAT rate$/) do |rate|
  @quotation = create(:billing_machine_quotation)
  create(:billing_machine_quotation_line, vat_rate: rate, quotation: @quotation)
end

Given(/^(\d+) associated documents to this quotation$/) do |n|
  n.to_i.times do |i|
    instance_variable_set "@document#{i}", create(:alexandrie_attachment, attachable: @quotation)
  end
end

Given(/^a bunch of existing quotations$/) do
  c1 = create(:customer_vault_corporation, name: "Bidule")
  c2 = create(:customer_vault_corporation, name: "Machin")
  c3 = create(:customer_vault_corporation, name: "Chose")

  i1 = create(:customer_vault_individual, first_name: "Oh")
  i2 = create(:customer_vault_individual, first_name: "Ah")
  i3 = create(:customer_vault_individual, first_name: "Eh")

  create(:billing_machine_quotation, customer: c1, date: Date.current)
  create(:billing_machine_quotation, customer: c2, date: Date.current)
  create(:billing_machine_quotation, customer: c3, date: Date.current)
  create(:billing_machine_quotation, customer: c1, date: Date.current - 2.days)
  create(:billing_machine_quotation, customer: i1, date: Date.current - 3.days)
  create(:billing_machine_quotation, customer: i2, date: Date.current - 3.days)
  create(:billing_machine_quotation, customer: i3, date: Date.current - 3.days)
end

Given(/^existing "(.*?)" quotations with "(.*?)" amount$/) do |n, amount|
  n.to_i.times do
    create(:billing_machine_quotation_line, quantity: 1, unit_price: amount)
  end
end

When(/^he changes the quotation VAT rate to "(.*?)"$/) do |arg1|
  fill_in "quotation_vat_rate", with: arg1
end

When(/^the user goes to the quotations page$/) do
  visit dorsale.billing_machine_quotations_path
end

When(/^the quotation line shows the right date$/) do
  page.should have_selector ".date", text: I18n.l(@quotation.date)
end

When(/^the quotation line shows the right traking\-id$/) do
  page.should have_selector ".tracking_id", text: @quotation.tracking_id
end

When(/^the quotation line shows the right customer's name$/) do
  page.should have_selector ".customer_name", text: @customer.name
end

When(/^the quotation line shows the right total excluding taxes value$/) do
  page.should have_selector ".total_excluding_taxes", text: "9,99 €"
end

When(/^the quotation line shows the right total including taxes value$/) do
  page.should have_selector ".total_including_taxes", text: "11,99 €"
end

When(/^the user goes to the quotation details$/) do
  visit dorsale.billing_machine_quotation_path(@quotation)
end

When(/^he creates a new quotation$/) do
  find(".link_create").click
end

When(/^he fills the reference and the date$/) do
  fill_in "quotation_label", with: @label = "My reference"
  fill_in "quotation_date", with: @date = "01/01/2014"
  select @payment_term.label
  fill_in "quotation_comments", with: "I-am-a-comment"
end

When(/^he saves the quotation$/) do
  find("[type=submit]").click
end

When(/^he goes on the edit page of the quotation$/) do
  visit dorsale.edit_billing_machine_quotation_path(@quotation)
end

When(/^changes the quotation label$/) do
  @new_label=  @quotation.label + " Edited"
  fill_in "quotation_label", with: @new_label
end

When(/^he copy the quotation$/) do
  @quotations_count = Dorsale::BillingMachine::Quotation.count
  find("[href$=copy]").click
end

When(/^he create an invoice from the quotation$/) do
  @invoices_count = Dorsale::BillingMachine::Invoice.count
  find("[href$='create_invoice']").click
  find("form#new_invoice [type=submit]").click
end

When(/^he fill the quotation expiry$/) do
  fill_in :quotation_expires_at, with: "21/12/2012"
end

Then(/^the document is not in the quotation details$/) do
  visit dorsale.billing_machine_quotation_path(@quotation)
  page.should have_link "pdf.pdf", count: 1
end

Then(/^a message signals the success of the quotation update$/) do
  page.should have_selector ".alert-success"
end

Then(/^he fill the quotation commercial discount with "(.*?)"$/) do |arg1|
  fill_in "quotation_commercial_discount", with: arg1
end

Then(/^the quotation's label has changed$/) do
  visit dorsale.edit_billing_machine_quotation_path(@quotation)
  page.should have_field("quotation_label", with: @new_label)
end

Then(/^I am on the created quotation$/) do
  @quotation = Dorsale::BillingMachine::Quotation.last_created
  expect(current_path).to eq dorsale.billing_machine_quotation_path(@quotation)
end

Then(/^he can see all the quotation informations$/) do
  expect(page).to have_selector ".quotation-label", text: @quotation.label
end

Then(/^the quotation default date is set to today's date\.$/) do
  page.should have_field("quotation_date", with: I18n.l(Date.current))
end

Then(/^he should see (\d+) quotations?$/) do |arg1|
  page.should have_selector ".quotation", count: arg1
end

Then(/^the quotation is displayed correctly$/) do
  expect(page).to have_selector ".tracking_id", text: @quotation.tracking_id
end

Then(/^a message signals the success of the quotation creation$/) do
  page.should have_selector ".alert-success"
end

Then(/^he will see links to the documents$/) do
  page.should have_link "pdf.pdf", count: 2
end

Then(/^the quotation informations are visible on the quotation details$/) do
  @quotation = ::Dorsale::BillingMachine::Quotation.last_created
  visit dorsale.billing_machine_quotation_path(@quotation)
  expect(page).to have_content @payment_term.label
  expect(page).to have_content "I-am-a-comment"
end

Then(/^only the quotations of this customer do appear$/) do
  expect(page).to have_selector(".customer_name", text: "Bidule", count: 2)
end

Then(/^only the quotations of today do appear$/) do
  expect(page).to have_selector(".quotation", count: 3)
end

Then(/^he is on the created quotation edit page$/) do
  expect(Dorsale::BillingMachine::Quotation.count).to eq(@quotations_count+1)
  @quotation = Dorsale::BillingMachine::Quotation.last_created
  expect(current_path).to eq dorsale.edit_billing_machine_quotation_path(@quotation)
end

Then(/^an invoice is created from quotation$/) do
  expect(Dorsale::BillingMachine::Invoice.count).to eq(@invoices_count+1)
  @invoice = Dorsale::BillingMachine::Invoice.last_created
  expect(@invoice.label).to eq @quotation.label
end

Then(/^the document is in the quotation details$/) do
  expect(page).to have_content "pdf.pdf"
end

When(/^he filters by "(.*?)" state$/) do |state|
  select find("option[value=#{state}]").text
  find(".filter-submit").click
end

Then(/^only the "(.*?)" quotations appear$/) do |state|
  state_i18n = find("option[value=#{state}]").text

  expect(page).to have_selector("tr.quotation", count: 1)
  expect(find("tr.quotation")).to have_content(state_i18n)
end

When(/^he send quotation to customer by email$/) do
  ActionMailer::Base.deliveries.clear

  Dorsale::BillingMachine::PdfFileGenerator.(@quotation)
  @quotation.customer = create(:customer_vault_corporation, email: "aaa@example.org")
  @quotation.save!

  find("[href$=email]").click
  fill_in :email_subject, with: "abc"
  fill_in :email_body, with: "def"
  find("[type=submit]").click
end

Then(/^an quotation is sent to customer$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 1
  email = ActionMailer::Base.deliveries.first

  expect(email.to).to include "aaa@example.org"
  expect(email.subject).to eq "abc"
  expect(email.parts.first.body).to eq "def"
  expect(email.attachments.count).to eq 1
end

When(/^he click on the preview quotation button$/) do
  @invoices_count = Dorsale::BillingMachine::Quotation.count
  controller = Dorsale::BillingMachine::QuotationsController
  expect_any_instance_of(controller).to receive(:preview).and_call_original
  expect_any_instance_of(controller).to_not receive(:create)
  expect_any_instance_of(controller).to_not receive(:update)
  find("#preview-button").click
end

Then(/^he see the quotation preview$/) do
  expect(windows.count).to eq 2
end

Then(/^no quotation is created$/) do
  expect(Dorsale::BillingMachine::Quotation.count).to eq @invoices_count
end
