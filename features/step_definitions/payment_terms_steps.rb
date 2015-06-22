When(/^the administrator goes to the payment terms administration page$/) do
  visit '/admin'
  step 'he goes to the payment terms page'
end

When(/^he goes to the new payment term page$/) do
  click_link 'Nouveau Payment Term'
end

When(/^he adds a payment term$/) do
  @new_payment_term = "My new payment term"
  fill_in "payment_term_label", with: @new_payment_term
  click_button 'Create Payment term'
end

Then(/^the payment term is added to the list$/) do
  options = all("#invoice_payment_term_id option", visible: :all).map(&:text)
  expect(options).to include @new_payment_term
end

Given(/^an existing payment term from the same entity$/) do
  @payment_term_same_entity = FactoryGirl.create(:payment_term,
      label: 'My payment term', entity: @entity)
end

Given(/^an existing payment term$/) do
  @payment_term = FactoryGirl.create(:payment_term, entity: @user.entity)
end

Given(/^an existing payment term from this other entity$/) do
  @payment_term_other_entity = FactoryGirl.create(:payment_term,
      label: 'Other payment term', entity: @other_entity)
end

When(/^he goes to the payment terms page$/) do
  click_on 'Payment Terms'
end

Then(/^he should see the payment term from his entity$/) do
  page.should have_content('My payment term')
end

Then(/^he should not see the payment term from another entity$/) do
  page.should have_no_content('Other payment term')
end

Then(/^he doesn't see the payment term's entity select field$/) do
  page.should have_no_selector '#payment_term_entity_id'
end
