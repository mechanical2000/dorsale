When(/^he try to access to the application$/) do
  visit root_path
  click_link "Connexion"
  fill_in "user_email", with: @user.email
  fill_in "user_password", with: @user.password
  find("[type=submit]").click
end

Then(/^a message signal that's the user is logged$/) do
  I18n.t("devise.sessions.signed_in")
end

Then(/^an error message signal that's account is inactive$/) do
  I18n.t("messages.users.inactive")
end
