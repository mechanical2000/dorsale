Given(/^the user goes on the new activity type page$/) do
  visit dorsale.customer_vault_activity_types_path
  find(".link_create").click
end

When(/^he fills the activity type's information$/) do
fill_in 'activity_type_name', with: "Activity Name"
end

When(/^creates a new activity type$/) do
  find("[type=submit]").click
end

Then(/^he is redirected on the activity types page$/) do
  expect(current_path).to eq dorsale.customer_vault_activity_types_path
end

Then(/^the activity type is added to the activity types list$/) do
  expect(page).to have_content "Activity Name"
end

Given(/^an existing activity type$/) do
  @activity_type = create(:customer_vault_activity_type)
end

When(/^I edit the activity type$/) do
  visit dorsale.customer_vault_activity_types_path
  find(".link_update").click
end

Then(/^the current activity type's name should be pre\-filled$/) do
  expect(page).to have_field("activity_type_name", with: @activity_type.name)
end

When(/^he validates the new activity type$/) do
  fill_in "activity_type_name", with: "New Activity Name"
  find("[type=submit]").click
end

Then(/^the activity type's label is updated$/) do
  expect(page).to have_content "New Activity Name"
end
