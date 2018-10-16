When(/^I export people list$/) do
  find("[href$=xlsx]").click
end

Then(/^the file is downloaded$/) do
  # Nothing to do, error appears in previous step if any problem
end

Given(/^a very long comment on this person$/) do
  text = Faker::Lorem.paragraph(30)
  @comment = create(:customer_vault_event_comment, person: @person, text: text)
end

Then(/^I see the truncated comment$/) do
  expect(page).to have_selector(".comment-text-truncated")
  expect(page).to have_no_selector(".comment-text")
end

Then(/^I see the full comment$/) do
  expect(page).to have_selector(".comment-text")
  expect(page).to have_no_selector(".comment-text-truncated")
end

Given(/^a short comment on this person$/) do
  @comment = create(:customer_vault_event_comment, person: @person, text: "i am short")
end
