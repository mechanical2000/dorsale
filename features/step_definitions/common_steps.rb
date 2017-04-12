When(/^I search "(.*?)"$/) do |q|
  fill_in "q", with: q
  find("form.search button").click
end

When(/^an existing customer$/) do
  @customer = create(:customer_vault_corporation)
end

When(/^he goes to the next page$/) do
  find(".next").click
end

Given(/^an existing id card$/) do
  @id_card = create(:billing_machine_id_card)
end

Given(/^an existing payment term$/) do
  @payment_term = create(:billing_machine_payment_term)
end

Given(/^an authenticated user$/) do
  @user = create(:user)
  sign_in @user
end

Given(/^an active user$/) do
  @user = create(:user)
end

Given(/^an inactive user$/) do
  @user = create(:user, is_active: false)
end

Given(/^an existing "(.*?)" having "(.*?)" set to "(.*?)"$/) do |factory, key, value|
  create(factory, key => value)
end

Then(/^the selected filter is "(.*?)"$/) do |value|
  selected_values = all(".filters select").map(&:value)
  expect(selected_values).to include value
end

Then(/^he do not see the "([^"]*)" filter$/) do |id|
  expect(page).to have_no_selector("#filters_#{id}")
end

When(/^he select custom date filter$/) do
  select "Choisir une date"
end

Then(/^he see the "([^"]*)" filter$/) do |id|
  expect(page).to have_selector("#filters_#{id}")
end

When(/^(?:I|he|she) export to XLSX$/) do
  find("a[href$=xlsx]").click
end

When(/^(?:I|he|she) download XLSX file$/) do
end

When(/^I click on show more$/) do
  find("a[class*=show_more]").click
end

When(/^I select "([^"]*)"$/) do |value|
  select value
end

When(/^I submit$/) do
  find("#main [type=submit]").click
end

When(/^I fill "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, with: value
end

Then(/^"([^"]*)" has value "([^"]*)"$/) do |field, expected_value|
  value = find_field(field).value
  expect(value).to eq expected_value
end

Then(/^I do not see "([^"]*)" element$/) do |element_selector|
  expect(page).to have_no_selector element_selector
end

Then(/^I see "([^"]*)" element$/) do |element_selector|
  expect(page).to have_selector element_selector
end
