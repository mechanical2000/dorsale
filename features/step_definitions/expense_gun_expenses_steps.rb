#encoding: utf-8

Etantdonné(/^une categorie de fras$/) do
  create(:expense_gun_category)
end

Lorsqu(/^il va dans l'espace de notes de frais$/) do
  visit dorsale.expense_gun_expenses_path(state: "all")
end

Lorsqu(/^il déclare un frais$/) do
  visit dorsale.new_expense_gun_expense_path
end

Lorsqu(/^il saisit le nom et la date de la note de frais puis valide$/) do
  fill_in "expense_gun_expense_name", with: "hello"
  fill_in "expense_gun_expense_date", with: "2012-12-21"
  find("[type=submit]").click
end

Alors(/^la note de frais est créée$/) do
  expect(page).to have_content "hello"
end

Alors(/^il déclare une ligne de frais$/) do
  find("a[href$='expense_lines/new']").click
end

Alors(/^il saisit les informations de la ligne de frais puis valide$/) do
  fill_in "expense_line_name", with: "taxi"
  fill_in "expense_line_date", with: "2012-12-21"
  select ::Dorsale::ExpenseGun::Category.first.name, from: "expense_line_category_id"
  fill_in "expense_line_total_all_taxes", with: 100
  fill_in "expense_line_vat", with: 20
  fill_in "expense_line_company_part", with: 50
  find("[type=submit]").click
end

Alors(/^la ligne de frais est créée$/) do
  expect(page).to have_content "hello"
  expect(page).to have_content "taxi"
end

Alors(/^le statut est à 'A soumettre'$/) do
  expect(page).to have_selector ".state.new"
end

Etantdonné(/^une note de frais$/) do
  @expense = create(:expense_gun_expense)
end

Lorsqu(/^il va sur le détail de la note de frais$/) do
  visit dorsale.expense_gun_expense_path(@expense)
end

Lorsqu(/^il modifie la note$/) do
  visit dorsale.edit_expense_gun_expense_path(@expense)
  fill_in "expense_gun_expense_name", with: "i-am-new-expense-name-value"
  find("[type=submit]").click
end

Alors(/^la modification de la note est prise en compte$/) do
  expect(page).to have_selector "h1", text: "i-am-new-expense-name-value"
end

Lorsqu(/^il modifie une ligne de la note$/) do
  visit dorsale.edit_expense_gun_expense_expense_line_path(@expense, @expense.expense_lines.first)
  fill_in "expense_line_name", with: "i-am-new-expense-line-name-value"
  find("[type=submit]").click
end

Alors(/^la modification de la ligne est prise en compte$/) do
  expect(page).to have_content "i-am-new-expense-line-name-value"
end

Lorsqu(/^il va sur la liste des notes de frais$/) do
  visit dorsale.expense_gun_expenses_path(state: "all")
end

Alors(/^il voit sa note$/) do
  expect(page).to have_content @expense.name
end

Lorsqu(/^il soumet sa note de frais$/) do
  url = dorsale.submit_expense_gun_expense_path(@expense)
  find("a[href='#{url}']").click
end

Alors(/^le manager est notifié$/) do
  pending # express the regexp above with the code you wish you had
end

Alors(/^la note de frais passe à l'état 'En attente de validation'$/) do
  expect(@expense.reload.current_state).to be :submited
  expect(page).to have_content ::I18n.t("expense_gun.expense.flash.submited")
end

Lorsqu(/^il annule la note de frais$/) do
  url = dorsale.cancel_expense_gun_expense_path(@expense)
  find("a[href='#{url}']").click
end

Alors(/^celle\-ci passe à l'état annulée$/) do
  expect(@expense.reload.current_state).to be :canceled
  expect(page).to have_content ::I18n.t("expense_gun.expense.flash.canceled")
end

Etantdonné(/^une note de frais soumise$/) do
  @expense = create(:expense_gun_expense, state: "submited")
end

Lorsqu(/^il va dans l'espace des notes à modérer$/) do
  visit dorsale.expense_gun_expenses_path(state: "submited")
end

Alors(/^la note de frais apparait$/) do
  expect(page).to have_content @expense.name
end

Lorsqu(/^il la valide$/) do
  find("a[href$='/accept']").click
end

Alors(/^celle\-ci passe à l'état validée$/) do
  expect(@expense.reload.current_state).to be :accepted
  expect(page).to have_content ::I18n.t("expense_gun.expense.flash.accepted")
end

Lorsqu(/^il la refuse$/) do
  find("a[href$='/refuse']").click
end

Alors(/^celle\-ci passe à l'état refusée$/) do
  expect(@expense.reload.current_state).to be :refused
  expect(page).to have_content ::I18n.t("expense_gun.expense.flash.refused")
end