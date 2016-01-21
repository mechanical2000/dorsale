if ENV["RAILS_ENV"] == "production"
  every :day, at: "7 am" do
    rake "cron:daily"
  end
end