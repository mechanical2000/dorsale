#encoding: utf-8
When(/^he can see the pdf download button$/) do
  page.should have_link('Télécharger', :href=>"/invoices/1.pdf")
end

When(/^the user download the pdf$/) do
  visit '/invoices/1.pdf'
end

Then(/^the Pdf should have the filename "([^\"]*)"$/) do |filename|
  page.driver.response.headers['Content-Disposition'].should include("filename=\"#{filename}\"")
end



