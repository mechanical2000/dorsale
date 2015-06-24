When(/^I create an new individual$/) do
  visit dorsale.new_customer_vault_individual_path
end

When(/^I add his first_name, last_name and email$/) do
  fill_in 'individual_first_name', with: 'Benoit'
  fill_in 'individual_last_name', with: 'Gantaume'
  fill_in 'individual_email', with: 'benoit@agilidee.com'
end

When(/^I fill the address$/) do
  fill_in 'individual_address_attributes_street', with: '3 Rue Marx Dormoy'
  fill_in 'individual_address_attributes_street_bis', with: ''
  fill_in 'individual_address_attributes_city', with: 'Marseille'
  fill_in 'individual_address_attributes_zip', with: '13004'
  fill_in 'individual_address_attributes_country', with: 'France'
end

When(/^I validate the new individual$/) do
  find("[type=submit]").click
end

Then(/^i see an error message for the missing names$/) do
  expect(page).to have_selector ".individual_first_name.has-error"
  expect(page).to have_selector ".individual_last_name.has-error"
end

Then(/^the individual is created with all the data provided$/) do
  expect(find(".individual-context")).to have_content "3 Rue Marx Dormoy, 13004 Marseille, France"
end

Given(/^an existing individual$/) do
  @individual = FactoryGirl.create(:customer_vault_individual)
end

When(/^I edit this individual$/) do
  visit dorsale.edit_customer_vault_individual_path(@individual)
end

When(/^I add tags to this individual$/) do
  page.execute_script %(
    $(".individual_tag_list select")[0].selectize.createItem("mytag1");
    $(".individual_tag_list select")[0].selectize.createItem("mytag2");
  )
end

When(/^I submit this individual$/) do
  find("[type=submit]").click
end

Given(/^an existing individual with tags$/) do
  @individual = FactoryGirl.create(:customer_vault_individual, tag_list: "mytag1, mytag2")
end

When(/^I remove tags to this individual$/) do
  page.execute_script %(
    $(".individual_tag_list select")[0].selectize.removeItem("mytag1");
  )
end

When(/^I go on this individual$/) do
  visit dorsale.customer_vault_individual_path(@individual)
end

