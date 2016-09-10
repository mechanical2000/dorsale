Given(/^(\d+) existing corporations$/) do |count|
  FactoryGirl.create_list(:customer_vault_corporation, Integer(count))
end

When(/^I create an new corporation$/) do
  visit dorsale.new_customer_vault_corporation_path
end

When(/^I add the corporation's informations$/) do
  fill_in 'corporation_name', with: 'AGILiDEE'
  fill_in 'corporation_email', with: 'contact@agilidee.com'
  fill_in 'corporation_www', with: 'www.agilidee.com'
  fill_in 'corporation_phone', with: '04 91 00 00 00'
  fill_in 'corporation_fax', with: '09 00 00 00 00'
end

When(/^I fill the corporation capital, immatriculation1, immatriculation2, legal form$/) do
  fill_in 'corporation_capital', with: '1000'
  fill_in 'corporation_immatriculation_number_1', with: 'RCS 201523658'
  fill_in 'corporation_immatriculation_number_2', with: 'SIREN 5485632569'
  fill_in 'corporation_legal_form', with: 'SARL'
end

When(/^I fill the corporation's address$/) do
  fill_in 'corporation_address_attributes_street', with: '3 Rue Marx Dormoy'
  fill_in 'corporation_address_attributes_street_bis', with: ''
  fill_in 'corporation_address_attributes_city', with: 'Marseille'
  fill_in 'corporation_address_attributes_zip', with: '13004'
  fill_in 'corporation_address_attributes_country', with: 'France'
end

When(/^I validate the new corporation$/) do
  find("[type=submit]").click
end

When(/^I go on the corporate index$/) do
  visit dorsale.customer_vault_people_list_path
end

When(/^he go on the next page$/) do
  click_link '2'
end

Then(/^i see an error message for the missing name$/) do
  expect(page).to have_selector ".corporation_name.has-error"
end

Then(/^he can see (\d+) corporate$/) do |count|
  page.should have_selector '.person', count: count
end

Then(/^the corporation is created with all the data provided$/) do
  expect(find(".corporation-context")).to have_content "3 Rue Marx Dormoy, 13004 Marseille, France"
  expect(find(".corporation-context")).to have_content "contact@agilidee.com"
  expect(find(".corporation-context")).to have_content "www.agilidee.com"
  expect(find(".corporation-context")).to have_content "04 91 00 00 00"
  expect(find(".corporation-context")).to have_content "09 00 00 00 00"
  expect(find(".corporation-context")).to have_content "1000"
  expect(find(".corporation-context")).to have_content "RCS 201523658"
  expect(find(".corporation-context")).to have_content "SIREN 5485632569"
  expect(find(".corporation-context")).to have_content "SARL"
end

When(/^I go on this corporation$/) do
  visit dorsale.customer_vault_corporation_path(@corporation)
end

When(/^I go on the activity section$/) do
  find("a[href$=activity]").click
end

When(/^I add a comment$/) do
  fill_in "comment_text", with: "Hello"
  find("[type=submit]").click
end

Then(/^the comment is saved$/) do
  expect(@corporation.comments.count).to eq 1
  find("a[href$=activity]").click
  expect(page).to have_content "Hello"
end

Given(/^an existing individual with recent comments$/) do
  @individual = create(:customer_vault_individual)
  @individual_comment1 = @individual.comments.create(text: "individual-comment-1", author: @user)
  @individual_comment2 = @individual.comments.create(text: "individual-comment-2", author: @user)
end

Given(/^an existing corporation with recent comments$/) do
  @corporation = create(:customer_vault_corporation)
  @corporation_comment1 = @corporation.comments.create(text: "corporation-comment-1", author: @user)
  @corporation_comment2 = @corporation.comments.create(text: "corporation-comment-2", author: @user)
end

When(/^I go on the people activity$/) do
  visit dorsale.customer_vault_people_activity_path
end

Then(/^I see all these comments$/) do
  expect(page).to have_content "individual-comment-1"
  expect(page).to have_content "individual-comment-2"
  expect(page).to have_content "corporation-comment-1"
  expect(page).to have_content "corporation-comment-2"
end

Given(/^an existing corporation with (\d+) comments$/) do |n|
  n.to_i.times do
    @corporation = create(:customer_vault_corporation)
    @corporation.comments.create(text: "abc", author: @user)
  end
end

Then(/^I see these comments paginated$/) do
  expect(all(".comment").count).to eq 50
  expect(page).to have_selector ".pagination"
end

When(/^I edit this corporation$/) do
  visit dorsale.edit_customer_vault_corporation_path(@corporation)
end

When(/^I add tags to this corporation$/) do
  page.execute_script %(
    $("#corporation_tag_list").append("<option value='mytag1'>mytag1</option>")
    $("#corporation_tag_list").append("<option value='mytag2'>mytag2</option>")
  )

  select "mytag1"
  select "mytag2"
end

When(/^I submit this corporation$/) do
  find("[type=submit]").click
end

Then(/^tags are added$/) do
  expect(all(".tag").count).to eq 2
  expect(page.body).to have_content "mytag1"
  expect(page.body).to have_content "mytag2"
end

Given(/^an existing corporation with tags$/) do
  @corporation = create(:customer_vault_corporation, tag_list: "mytag1, mytag2")
end

When(/^I remove tags to this corporation$/) do
  unselect "mytag1"
end

Then(/^tags are removed$/) do
  expect(all(".tag").count).to eq 1
  expect(page.body).to_not have_content "mytag1"
  expect(page.body).to have_content "mytag2"
end

Given(/^an open task to this corporation$/) do
  @open_task = ::Dorsale::Flyboy::Task.create!(taskable: @corporation, progress: 20, name: "I-am-open")
end

Given(/^a closed task to this corporation$/) do
  @closed_task = ::Dorsale::Flyboy::Task.create!(taskable: @corporation, progress: 100, done: true, name: "I-am-closed")
end

Given(/^a link between this individual and this corporation$/) do
  @link = ::Dorsale::CustomerVault::Link.create!(alice: @corporation, bob: @individual, title: "I-am-a-link")
end

Then(/^I see only the open task in the context$/) do
  expect(find(".person-context")).to have_content "I-am-open"
  expect(find(".person-context")).to_not have_content "I-am-closed"
end

Then(/^I see the link in the context$/) do
  expect(find(".person-context")).to have_content "I-am-a-link"
end
