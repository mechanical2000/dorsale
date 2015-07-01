When(/^I search "(.*?)"$/) do |q|
  fill_in "q", with: q
  find("form.search button").click
end

When(/^an existing customer$/) do
  @customer = create(:customer_vault_corporation)
end

When(/^he goes to the next page$/) do
  find(".next").click
end

Given(/^an existing id card$/) do
  @id_card = create(:billing_machine_id_card)
end

Given(/^an existing payment term$/) do
  @payment_term = create(:billing_machine_payment_term)
end
