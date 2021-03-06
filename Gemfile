source "https://rubygems.org"

ruby_version_file = File.join(__dir__, ".ruby-version")
if File.exist?(ruby_version_file)
  ruby File.read(ruby_version_file).strip
else
  puts ".ruby-version file not found"
end

gem "rails", "~> 6.1.0"
gem "agilibox", ">= 1.9.18"

gem "spreadsheet_architect"
gem "bootsnap"
gem "devise"
gem "devise-bootstrap-views"
gem "devise-i18n"
gem "pg"
gem "uglifier"
gem "puma"
gem "font-awesome-sass", "~> 4.7.0"
gem "sass-rails", "< 6"
gem "bootstrap-sass"
gem "select2-rails"

gemspec

group :test do
  gem "minitest"
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "rspec-repeat"
  gem "shoulda-matchers"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "ferrum"
  gem "cuprite"
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"
  gem "timecop"
  gem "simplecov", require: false
  gem "pundit-matchers"
  gem "zonebie"
end

group :development do
  gem "desktop_delivery"
  gem "better_errors"
  gem "bullet"
  gem "listen"
end

group :development, :test do
  gem "spring"
  gem "launchy"
  gem "rails-erd"
  gem "thor"
  gem "faker"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "byebug"
  gem "rspec-rails" # must be in both environments for generators
  gem "rubocop", "1.6.1", require: false
  gem "rubocop-performance", "1.9.1", require: false
  gem "rubocop-rails", "2.9.1", require: false
end
