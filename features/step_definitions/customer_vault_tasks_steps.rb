When(/^I go on the tasks section$/) do
  find("#person-tabs a[href$='tasks']").click
end

When(/^I create a task on this person$/) do
  @tasks_count = ::Dorsale::Flyboy::Task.count
  find("#context-main a[href*='tasks/new']").click
  fill_in :task_name, with: "YepYep"
  fill_in :task_description, with: "Trololo"
  find("[type=submit]").click
end

Then(/^the person task is created$/) do
  expect(::Dorsale::Flyboy::Task.count).to eq(@tasks_count + 1)
  @task = ::Dorsale::Flyboy::Task.last_created
  person = @corporation || @individual || @person
  expect(current_path).to eq dorsale.tasks_customer_vault_person_path(person)
end

Then(/^the task appear$/) do
  expect(page).to have_content "YepYep"
end

When(/^I go on the general tasks page$/) do
  visit dorsale.flyboy_tasks_path
end

When(/^I filter tasks$/) do
  find(".filter-submit").click
end

Then(/^I an redirected on the tasks tab$/) do
  expect(current_path).to eq dorsale.tasks_customer_vault_person_path(@individual)
end
