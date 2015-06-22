When(/^I search "(.*?)"$/) do |q|
  fill_in "q", with: q
  find("form.search button").click
end
