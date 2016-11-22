When(/^I export people list$/) do
  find("[href$=xlsx]").click
end

Then(/^the file is downloaded$/) do
  # Nothing to do, error appears in previous step if any problem
end
