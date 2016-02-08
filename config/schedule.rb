if ENV["RAILS_ENV"] == "production"
  every :day, at: "7 am" do
    Dorsale::Flyboy::TaskCommands.send_daily_term_emails
  end
end
