#encoding: utf-8

# When(/^he sets a due date$/) do
#   fill_in 'invoice_due_date', with: @due_date = '08/05/2014'
# end

# Then(/^the due date is still there$/) do
#   page.should have_field('invoice_due_date', with: @due_date)
# end

Given(/^an existing unpaid invoice$/) do
  @invoice = FactoryGirl.create(:invoice, id_card: @user.entity.current_id_card,
                                paid: false)
end

Given(/^its due date is not yet passed$/) do
  @invoice.update(due_date: (Date.today + 1))
end

Given(/^its due date is the same day$/) do
  @invoice.update(due_date: (Date.today))
end

Given(/^its due date is yesterday$$/) do
  @invoice.update(due_date: (Date.today - 1))
end

Given(/^its due date is (\d+) days ago$/) do |days|
  @invoice.update(due_date: (Date.today - days.to_i))
end

Then(/^the invoice paid status should not have a color$/) do
  find(".invoice")[:class].should_not include("paid", "late", "onalert")
end

Then(/^the invoice status should be "(.*?)"$/) do |color|
  find(".invoice")[:class].should include(color)
end
