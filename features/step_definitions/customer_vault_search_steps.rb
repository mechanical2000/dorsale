When(/^he go to the people list$/) do
  visit dorsale.customer_vault_people_path
end

Given(/^existing individuals$/) do
  @individual1 = create(:customer_vault_individual, first_name: "Jean", last_name: "DUPONT")
  @individual2 = create(:customer_vault_individual, first_name: "Laurent", last_name: "DURAND")
end

Given(/^existing corporations$/) do
  @corporation1 = create(:customer_vault_corporation, name: "aaa", email: "contact@aaa.com")
  @corporation2 = create(:customer_vault_corporation, name: "zzz", email: "contact@zzz.com")
end

When(/^he search an individual by first name$/) do
  fill_in "q", with: "Jean"
  find(".search-submit").click
end

Then(/^this individual appear in search results$/) do
  expect(page).to have_content "Jean"
  expect(page).to have_content "DUPONT"
end

Then(/^other individuals do not appear in search results$/) do
  expect(page).to have_no_content "Laurent"
  expect(page).to have_no_content "DURAND"
end

When(/^he search an individual by last name$/) do
  fill_in "q", with: "DUPONT"
  find(".search-submit").click
end

When(/^he search a corporation by name$/) do
  fill_in "q", with: "aaa"
  find(".search-submit").click
end

Then(/^this corporation appear in search results$/) do
  expect(page).to have_content "aaa"
  expect(page).to have_content "contact@aaa.com"
end

Then(/^other corporations do not appear in search results$/) do
  expect(page).to have_no_content "zzz"
  expect(page).to have_no_content "contact@zzz.com"
end
