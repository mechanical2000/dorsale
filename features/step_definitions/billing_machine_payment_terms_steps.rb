Given(/^the user goes on the new paymentterm page$/) do
  visit dorsale.billing_machine_payment_terms_path
  find(".link_create").click
end

When(/^he fills the paymentterm's information$/) do
  fill_in 'billing_machine_payment_term_label', with: "Payment Term Label"
end

When(/^creates a new paymentterm$/) do
  find("[type=submit]").click
end

Then(/^he is redirected on the paymentterms page$/) do
  expect(current_path).to eq dorsale.billing_machine_payment_terms_path
end

Then(/^the paymentterm is added to the paymentterm list$/) do
  expect(page).to have_content "Payment Term Label"
end

Given(/^an existing paymentterm$/) do
  @paymentterm = create(:billing_machine_payment_term)
end

When(/^the user edits the paymentterm$/) do
  visit dorsale.billing_machine_payment_terms_path
  find(".link_update").click
end

Then(/^the current paymentterm's label should be pre\-filled$/) do
  expect(page).to have_field("billing_machine_payment_term_label", with: @paymentterm.label)
end

When(/^he validates the new paymentterm$/) do
  fill_in "billing_machine_payment_term_label", with: "New Payment Term Label"
  find("[type=submit]").click
end

Then(/^the paymentterm's label is updated$/) do
  expect(page).to have_content "New Payment Term Label"
end