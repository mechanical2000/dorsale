source "https://rubygems.org"

gem "rails", "~> 4.2.1"
gem 'devise'
gem "database_cleaner"

gemspec

group :production, :development do
  gem 'pg'
  gem 'uglifier'
  gem "whenever"
  gem "exception_notification"
end

group :development, :test do
  gem "thor"
  gem "pry"
  gem "sqlite3"
  gem "zeus"
  gem "rspec-rails"
  gem "minitest"
  gem "shoulda-matchers", "2.5.0"
  gem "faker"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "poltergeist"
  gem "factory_girl_rails"
  gem "guard"
  gem "guard-cucumber"
  gem "guard-rspec"
  gem "guard-rubocop"
  gem "timecop"
  gem "pdf-inspector"
  gem "yomu"
end
