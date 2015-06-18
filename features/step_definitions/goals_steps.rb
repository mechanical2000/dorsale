# encoding: utf-8

When(/^I go to the goals section$/) do
  visit dorsale.flyboy_goals_path
end

When(/^I create a new goal$/) do
  find("a[href$='goals/new']").click
  fill_in "goal_name", with: "I-am-the-goal-title"
  fill_in "goal_description", with: "I-am-the-goal-description"
  find("form[id*=goal] [type=submit]").click
end

Then(/^I am on this goal$/) do
  expect(current_path).to eq dorsale.flyboy_goal_path(@goal)
end

Then(/^I am on the created goal$/) do
  @goal = Dorsale::Flyboy::Goal.order("id DESC").first
  expect(current_path).to eq dorsale.flyboy_goal_path(@goal)
end

Then(/^the goal is created$/) do
  expect(page).to have_content "I-am-the-goal-title"
end

Then(/^the goal is opened$/) do
  expect(page).to have_content "Ouvert"
end

Given(/^an existing goal$/) do
  @goal = FactoryGirl.create(:flyboy_goal)
end

Given(/^(\d+) tasks in this goal$/) do |n|
  n.to_i.times do
    FactoryGirl.create(:flyboy_task, taskable: @goal)
  end
end

When(/^I consult this goal$/) do
  visit dorsale.flyboy_goals_path
  click_link @goal.name
end

Then(/^I see this goal$/) do
  expect(current_path).to eq dorsale.flyboy_goal_path(@goal)
  expect(page).to have_content @goal.name
  expect(page).to have_content @goal.description
  expect(page).to have_content @goal.tracking
end

Then(/^I see the goal tasks$/) do
  @goal.tasks.map do |task|
    expect(page).to have_content task.name
  end
end

When(/^I update this goal$/) do
  click_link @goal.name
  find("a[href$='goals/#{@goal.id}/edit']").click
  fill_in "goal_name", with: "New-goal-title"
  find("form[id*=goal] [type=submit]").click
end

Then(/^I am on the updated goal$/) do
  expect(current_path).to eq dorsale.flyboy_goal_path(@goal)
end

Then(/^the goal is updated$/) do
  expect(page).to have_content "New-goal-title"
end

When(/^I delete this goal$/) do
  click_link @goal.name
  find("a[href$='goals/#{@goal.id}/edit']").click
  find(".goal-context a[data-method=delete]").click
end

Then(/^I am on the goals section$/) do
  expect(current_path).to eq dorsale.flyboy_goals_path
end

Then(/^the goal is deleted$/) do
  expect(page).to_not have_content @goal.name
end

When(/^I close this goal$/) do
  visit dorsale.flyboy_goal_path(@goal)
  find("a[href$='goals/#{@goal.id}/close']").click
end

Then(/^the goal is closed$/) do
  expect(page).to have_content "Fermé"
end

Given(/^an existing closed goal$/) do
  @closed_goal = FactoryGirl.create(:flyboy_goal, status: "closed")
  @goal = @closed_goal
end

When(/^I reopen this goal$/) do
  visit dorsale.flyboy_goal_path(@goal)
  find("a[href$='goals/#{@goal.id}/open']").click
end

Given(/^an existing open goal$/) do
  @open_goal = FactoryGirl.create(:flyboy_goal, status: "open")
  @goal = @open_goal
end

When(/^I filter goals by open$/) do
  select "Ouvert"
  find(".filters [type=submit]:last-child").click
end

Then(/^only open goals appear$/) do
    expect(page).to have_content @open_goal.name
    expect(page).to_not have_content @closed_goal.name
end

When(/^I filter goals by closed$/) do
  select "Fermé"
  find(".filters [type=submit]:last-child").click
end

Then(/^only closed goals appear$/) do
  expect(page).to have_content @closed_goal.name
  expect(page).to_not have_content @open_goal.name
end

Then(/^all goals appear$/) do
  expect(page).to have_content @open_goal.name
  expect(page).to have_content @closed_goal.name
end

Given(/^an existing goal named "(.*?)"$/) do |name|
  FactoryGirl.create(:flyboy_goal, name: name)
end

Then(/^only the "Hello" goal appear$/) do
  expect(page).to have_content "Hello"
  expect(page).to_not have_content "World"
end

Given(/^(\d+) existing goals$/) do |n|
  n.to_i.times do
    FactoryGirl.create(:flyboy_goal)
  end
end

Then(/^goals are paginated$/) do
  expect(all("tr.goal").count).to eq 50
  expect(page).to have_selector ".pagination"
end
