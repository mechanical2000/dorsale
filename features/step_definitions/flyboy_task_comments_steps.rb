When(/^I create a new task comment$/) do
  fill_in "task_comment_progress", with: "50"
  fill_in "task_comment_description", with: "I-am-the-task-comment-description"
  find("form[id*=task_comment] [type=submit]").click
end

Then(/^the task comment is created$/) do
  expect(@task.comments.count).to eq 1
  expect(page).to have_content "I-am-the-task-comment-description"
end
