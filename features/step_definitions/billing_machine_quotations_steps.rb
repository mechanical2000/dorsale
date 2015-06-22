Given(/^an existing quotation$/) do
  @quotation = create(:quotation, id_card: @id_card, customer: @customer)
  @quotation.lines.create(quantity: 1, unit_price: 9.99)
end

Given(/^(\d+) existing quotations$/) do |arg1|
  create_list(:quotation, Integer(arg1), id_card: @id_card)
end

Given(/^an existing emtpy quotation$/) do
  @quotation = create(:billing_machine_quotation, label: nil, customer: nil, id_card: @id_card)
  @quotation.date = nil
  @quotation.save(validate: false)
end

Given(/^an existing quotation with a "(.*?)"% VAT rate$/) do |arg1|
  @quotation = create(:quotation, id_card: @id_card, vat_rate: arg1)
end

Given(/^(\d+) associated documents to this quotation$/) do |arg1|
  @document1 = create(:document, quotation: @quotation, document_file_name: 'document1.pdf')
  @document2 = create(:document, quotation: @quotation, document_file_name: 'document2.pdf')
end

When(/^he changes the quotation VAT rate to "(.*?)"$/) do |arg1|
  fill_in 'quotation_vat_rate', with: arg1
end

When(/^the user goes to the quotations page$/) do
  visit dorsale.billing_machine_quotations_path
end

When(/^the quotation line shows the right date$/) do
  page.should have_selector '.date' , text: I18n.l(@quotation.date)
end

When(/^the quotation line shows the right traking\-id$/) do
  page.should have_selector '.tracking-id' , text: @quotation.tracking_id
end

When(/^the quotation line shows the right customer's name$/) do
  page.should have_selector '.customer-name', text: @customer.name
end

When(/^the quotation line shows the right total\-duty value$/) do
  page.should have_selector '.total-duty' , text: "9,99 €"
end

When(/^the quotation line shows the right all taxes value$/) do
  page.should have_selector '.all-taxes' , text: "11,99 €"
end

When(/^the user goes to the quotation details$/) do
  visit dorsale.billing_machine_quotation_path(@quotation)
end

When(/^he fills an quotation line with "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/) do |arg1, arg2, arg3, arg4|
  within(all('.quotation-line').last()) do
    find(:css,"input.line-label").set(arg1)
    find(:css,"input.line-quantity").set arg2
    find(:css,"input.line-unit").set arg3
    find(:css,"input.line-unit_price").set arg4
  end
end

When(/^he creates a new quotation$/) do
  find(".icon_button_create").click
end

When(/^he fills the reference and the date$/) do
  fill_in 'quotation_label', with: @label = 'My reference'
  fill_in 'quotation_date', with: @date = '01/01/2014'
  select @payment_term.label
  fill_in 'quotation_comments', with: "I-am-a-comment"
end

When(/^he saves the quotation$/) do
  click_button 'quotation-submit'
end

When(/^he goes on the edit page of the quotation$/) do
  visit dorsale.billing_machine_edit_quotation_path(@quotation)
end

When(/^changes the quotation label$/) do
  @new_label=  @quotation.label + " Edited"
  fill_in 'quotation_label', with: @new_label
end

When(/^he check one of the documents checkbox$/) do
  check('quotation[documents_attributes][0][_destroy]')
end

Then(/^the document is not in the quotation details$/) do
  visit dorsale.billing_machine_quotation_path(@quotation)
  page.should have_content 'Documents associés:'
  page.should have_link 'document2'
end

Then(/^the quotation new line total is "(.*?)"$/) do |arg1|
 page.should have_selector '.quotation-line .line-total', text: arg1
end

Then(/^the existing quotation line total is "(.*?)"$/) do |arg1|
  page.should have_selector '.quotation-line .line-total', text: arg1
end

Then(/^a message signals the success of the quotation update$/) do
  find('.alert-success').should be_visible
  page.should have_selector '.alert-success', text: "Devis mis à jour."
end

Then(/^the quotation's label has changed$/) do
  visit dorsale.billing_machine_edit_quotation_path(@quotation)
  page.should have_field('quotation_label', with: @new_label)
end

Then(/^it's added to the quotation list$/) do
  page.should have_selector '.quotation .date', text: @date
  tracking_id = Quotation.first.tracking_id
  page.should have_selector '.quotation .tracking-id', text: tracking_id
  page.should have_selector '.quotation .customer-name', text: @customer.name
  page.should have_selector '.quotation .total-duty', text: '200,00 €'
end

Then(/^he can see all the quotation informations$/) do
  expect(page).to have_selector '.quotation-label', @quotation.label
end

Then(/^the quotation default date is set to today's date\.$/) do
  page.should have_field('quotation_date', with: I18n.l(Date.today))
end

Then(/^he should see (\d+) quotations$/) do |arg1|
  page.should have_selector '.quotation', count: arg1
end

Then(/^the quotation is displayed correctly$/) do
  expect(page).to have_selector '.tracking-id', @quotation.tracking_id
end

Then(/^the quotation total duty is "(.*?)"$/) do |arg1|
  page.should have_selector '.total #quotation-total_duty', text: arg1
end

Then(/^the quotation VAT due is "(.*?)"$/) do |arg1|
  page.should have_selector '.total #quotation-vat_amount', text: arg1
end

Then(/^the quotation total all taxes included is "(.*?)"$/) do |arg1|
  page.should have_selector '.total #quotation-total_all_taxes', text: arg1
end

Then(/^a message signals the success of the quotation creation$/) do
  find('.alert-success').should be_visible
  page.should have_selector '.alert-success', text: "Devis sauvegardé."
end

Then(/^the quotation VAT rate is "(.*?)"$/) do |arg1|
  page.should have_field('quotation_vat_rate', with: arg1)
end

Then(/^he will see links to the documents$/) do
  page.should have_content 'Documents associés:'
  page.should have_link 'document1'
  page.should have_link 'document2'
end

Then(/^he dont see the documents section$/) do
  page.should_not have_content 'Documents associés:'
end

Then(/^the quotation informations are visible on the quotation details$/) do
  @quotation = Quotation.order(:id).last
  visit dorsale.billing_machine_quotation_path(@quotation)
  expect(page).to have_content @payment_term.label
  expect(page).to have_content "I-am-a-comment"
end
