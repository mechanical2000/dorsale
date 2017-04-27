Given(/^the user goes on the new origin page$/) do
  visit dorsale.customer_vault_origins_path
  find(".link_create").click
end

When(/^he fills the origin's information$/) do
fill_in 'origin_name', with: "Origin Name"
end

When(/^creates a new origin$/) do
  find("[type=submit]").click
end

Then(/^he is redirected on the origins page$/) do
  expect(current_path).to eq dorsale.customer_vault_origins_path
end

Then(/^the origin is added to the origin list$/) do
  expect(page).to have_content "Origin Name"
end

Given(/^an existing origin$/) do
  @origin = create(:customer_vault_origin)
end

When(/^I edit the origin$/) do
  visit dorsale.customer_vault_origins_path
  find(".link_update").click
end

Then(/^the current origin's name should be pre\-filled$/) do
  expect(page).to have_field("origin_name", with: @origin.name)
end

When(/^he validates the new origin$/) do
  fill_in "origin_name", with: "New Origin Name"
  find("[type=submit]").click
end

Then(/^the origin's label is updated$/) do
  expect(page).to have_content "New Origin Name"
end
