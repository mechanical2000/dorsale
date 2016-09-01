Given(/^the user goes on the new idcard page$/) do
  visit dorsale.billing_machine_id_cards_path
  find(".link_create").click
end

Given(/^an existing idcard$/) do
  @idcard = create(:billing_machine_id_card)
end

When(/^he fills the idcard's information$/) do
  fill_in 'billing_machine_id_card_id_card_name', with: "Id Card name"
  fill_in 'billing_machine_id_card_entity_name', with: "Id Card entity name"
  fill_in 'billing_machine_id_card_contact_full_name', with: "Id Card contact full name"
end

When(/^creates a new idcard$/) do
  find("[type=submit]").click
end

Then(/^he is redirected on the idcards page$/) do
  expect(current_path).to eq dorsale.billing_machine_id_cards_path
end

Then(/^the idcard is added to the idcard list$/) do
  expect(page).to have_content "Id Card name"
  expect(page).to have_content "Id Card entity name"
  expect(page).to have_content "Id Card contact full name"

end

Then(/^the current idcard's label should be pre\-filled$/) do
  expect(page).to have_field("billing_machine_id_card_id_card_name", with: @idcard.id_card_name)
  expect(page).to have_field("billing_machine_id_card_entity_name", with: @idcard.entity_name)
  expect(page).to have_field("billing_machine_id_card_contact_full_name", with: @idcard.contact_full_name)
end

When(/^the user edits the idcard$/) do
  visit dorsale.billing_machine_id_cards_path
  find(".link_update").click
end

When(/^he validates the new idcard$/) do
  fill_in "billing_machine_id_card_id_card_name", with: "New Id Card Name"
  fill_in "billing_machine_id_card_entity_name", with: "New Id Card Entity Name"
  fill_in "billing_machine_id_card_contact_full_name", with: "New Id Card Contact Full Name"
  find("[type=submit]").click
end

Then(/^the idcard's label is updated$/) do
  expect(page).to have_content "New Id Card Name"
  expect(page).to have_content "New Id Card Entity Name"
  expect(page).to have_content "New Id Card Contact Full Name"
end