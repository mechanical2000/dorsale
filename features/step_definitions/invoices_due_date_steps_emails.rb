#encoding: utf-8

require "rake"

Given(/^an existing user who wants to be notified about late invoices payments$/) do
  @user = FactoryGirl.create(:user, notify_invoices_late_payments: true)
end

When(/^the nightly cron runs$/) do
  @email_count = ActionMailer::Base.deliveries.count
  @rake = Rake::Application.new
  Rake.application = @rake
  # Ruse pour que cucumber recharge les tâches rake correctement!
  loaded = $".reject {|file| file == Rails.root.join("lib", "tasks", "cron.rake").to_s }
  Rake.application.rake_require("lib/tasks/cron", [Rails.root.to_s], loaded)
  Rake::Task.define_task(:environment)
  @rake['cron:daily'].execute
end

Then(/^the user is notified$/) do
  ActionMailer::Base.deliveries.count.should eq(@email_count+1)
  @email = ActionMailer::Base.deliveries.last
  @email.to.should eq [@user.email]
end
