Given(/^billing machine in multiple vat mode$/) do
  ::Dorsale::BillingMachine.vat_mode = :multiple
end

When(/^he fills the reference, the date and the payment terms$/) do
  fill_in 'invoice_label', with: @label = 'My reference'
  fill_in 'invoice_date', with: @date = '01/01/2014'
  select @payment_term.label
end

When(/^he fills a multiple vat line with "(.*?)", "(.*?)", "(.*?)", "(.*?)", "(.*?)"$/) do |label, quantity, unit, vat_rate, unit_price|
  within all('.line').last do
    find(".line-label textarea").set label
    find(".line-quantity input").set  quantity
    find(".line-unit input").set  unit
    find(".line-vat_rate input").set vat_rate
    find(".line-unit_price input").set unit_price
  end
end

