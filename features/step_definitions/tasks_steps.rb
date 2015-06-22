# encoding: utf-8

When(/^I create a task$/) do
  find("a[href*='tasks/new']").click
  fill_in "task_name", with: "I-am-the-task-title"
  fill_in "task_description", with: "I-am-the-task-description"
  find("form[id*=task] [type=submit]").click
end

Then(/^I am on the created task$/) do
  @task = Dorsale::Flyboy::Task.order("id DESC").first
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Then(/^the task is created$/) do
  expect(page).to have_content "I-am-the-task-title"
  expect(page).to have_content "I-am-the-task-description"
end

Given(/^an existing task$/) do
  @task = FactoryGirl.create(:flyboy_task)
end

When(/^I go to the tasks section$/) do
  visit dorsale.flyboy_tasks_path
end

When(/^I consult this task$/) do
  click_link @task.name
end

Then(/^I see this task$/) do
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

When(/^I update this task$/) do
  visit dorsale.flyboy_task_path(@task)
  find("a[href$='tasks/#{@task.id}/edit']").click
  fill_in "task_name", with: "New-task-title"
  find("form[id*=task] [type=submit]").click
end

Then(/^I am on the updated task$/) do
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Then(/^the task is updated$/) do
  expect(page).to have_content "New-task-title"
end

When(/^I delete this task$/) do
  visit dorsale.flyboy_task_path(@task)
  find("a[href$='tasks/#{@task.id}/edit']").click
  find(".task-context a[data-method=delete]").click
end

Then(/^I am on the tasks section$/) do
  expect(current_path).to eq dorsale.flyboy_tasks_path
end

Then(/^the task is deleted$/) do
  expect(page).to_not have_content @task.name
end

When(/^I complete this task$/) do
  find("a[href$=complete]").click
end

Then(/^the task is completed$/) do
  expect(page).to have_content "100%"
end

Given(/^an existing snoozable task$/) do
  FactoryGirl.create(:flyboy_task,
    :reminder => Date.yesterday,
    :term     => Date.today
  )
end

When(/^I snooze this task$/) do
  find("a[href*=snooze]").click
end

Then(/^the task is snoozed$/) do
  expect(all("a[href*=snooze]").count).to eq 0
end

Given(/^(\d+) existing tasks$/) do |n|
  n.to_i.times do
    FactoryGirl.create(:flyboy_task)
  end
end

When(/^I export tasks to PDF$/) do
  find("a[href$=pdf]").click
end

Then(/^I download PDF file$/) do
  expect(page.status_code).to eq 200
  expect(page.response_headers['Content-Type']).to eq "application/pdf"
end

When(/^I export tasks to CSV$/) do
  find("a[href$=csv]").click
end

Then(/^I download CSV file$/) do
  expect(page.status_code).to eq 200
  expect(page.response_headers['Content-Type']).to eq "text/csv"
end

When(/^I export tasks to XLS$/) do
  find("a[href$=xls]").click
end

Then(/^I download XLS file$/) do
  expect(page.status_code).to eq 200
  expect(page.response_headers['Content-Type']).to match "excel"
end

Then(/^I am on this task$/) do
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Given(/^an existing done task$/) do
  @done_task = FactoryGirl.create(:flyboy_task, done: true)
end

Given(/^an existing undone task$/) do
  @undone_task = FactoryGirl.create(:flyboy_task, done: false)
end

When(/^I filter tasks by done$/) do
  select "Fermé"
  find(".filters [type=submit]:last-child").click
end

Then(/^only done tasks appear$/) do
  expect(page).to have_content @done_task.name
  expect(page).to_not have_content @undone_task.name
end

When(/^I filter tasks by undone$/) do
  select "Ouvert"
  find(".filters [type=submit]:last-child").click
end

Then(/^only undone tasks appear$/) do
  expect(page).to_not have_content @done_task.name
  expect(page).to have_content @undone_task.name
end

When(/^I reset filters$/) do
  find(".filters .reset").click
end

Then(/^all tasks appear$/) do
  expect(page).to have_content @done_task.name
  expect(page).to have_content @undone_task.name
end

Given(/^an existing task named "(.*?)"$/) do |name|
  FactoryGirl.create(:flyboy_task, name: name)
end

Then(/^only the "Hello" task appear$/) do
  expect(page).to have_content "Hello"
  expect(page).to_not have_content "World"
end

Then(/^tasks are paginated$/) do
  expect(all("tr.task").count).to eq 50
  expect(page).to have_selector ".pagination"
end
