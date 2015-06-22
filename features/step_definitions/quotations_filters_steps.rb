#encoding: utf-8

Given(/^a bunch of existing quotations$/) do
  c1 = FactoryGirl.create(:corporation, entity: @user.entity, name: 'Bidule')
  c2 = FactoryGirl.create(:corporation, entity: @user.entity, name: 'Machin')
  c3 = FactoryGirl.create(:corporation, entity: @user.entity, name: 'Chose')

  i1 = FactoryGirl.create(:individual, entity: @user.entity, first_name: 'Oh')
  i2 = FactoryGirl.create(:individual, entity: @user.entity, first_name: 'Ah')
  i3 = FactoryGirl.create(:individual, entity: @user.entity, first_name: 'Eh')

  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: c1, date: Date.today)
  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: c2, date: Date.today)
  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: c3, date: Date.today)
  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: c1, date: Date.today - 2.days)

  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: i1, date: Date.today - 3.days)
  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: i2, date: Date.today - 3.days)
  FactoryGirl.create(:quotation, id_card: @user.entity.current_id_card, customer: i3, date: Date.today - 3.days)
end

Then(/^only the quotations of this customer do appear$/) do
  expect(page).to have_selector(".customer-name", text: 'Bidule', count: 2)
end

Then(/^only the quotations of today do appear$/) do
  expect(page).to have_selector(".quotation", count: 3)
end
