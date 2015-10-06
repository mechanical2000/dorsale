Given(/^an expired tasks$/) do
  @task = create(:flyboy_task, taskable: @folder, owner: @user, term: Date.today-1)
end

Given(/^a task that expire tommorow$/) do
 @task = create(:flyboy_task, taskable: @folder, owner: @user, term: Date.today+1)
end

Given(/^a task that expire today$/) do
  @task = create(:flyboy_task, taskable: @folder, owner: @user, term: Date.today)
end

When(/^he go to the tasks summary page$/) do
  visit dorsale.summary_flyboy_tasks_path
end

Then(/^the task is classed as 'expired'$/) do
  expect(page).to have_content('Delayed')
  expect(page).to have_content(@task.name)
end

Then(/^the task is classed as 'Expire Today'$/) do
  expect(page).to have_content('Today')
  expect(page).to have_content(@task.name)
end

Then(/^the task is classed as 'Expire tommorow'$/) do
  expect(page).to have_content('Tomorrow')
  expect(page).to have_content(@task.name)
end
