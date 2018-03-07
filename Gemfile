source "https://rubygems.org"

ruby_version_file = File.join(__dir__, ".ruby-version")
if File.exists?(ruby_version_file)
  ruby File.read(ruby_version_file).strip
else
  puts ".ruby-version file not found"
end

gem "rails", "~> 5.0.0"
gem "agilibox", ">= 1.0.9"
gem "axlsx", github: "randym/axlsx"

gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'pg'
gem 'uglifier'
gem "puma"
gem "font-awesome-sass", "~> 4.7.0"

gemspec

group :test do
  gem "minitest"
  gem "rspec-wait"
  gem "rails-controller-testing"
  gem "rspec-repeat"
  gem "shoulda-matchers"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "poltergeist"
  gem "spring-commands-rspec"
  gem "spring-commands-cucumber"
  gem "guard"
  gem "guard-cucumber"
  gem "guard-rspec", "4.5.2" # https://github.com/guard/guard-rspec/issues/334
  gem "guard-rubocop"
  gem "timecop"
  gem "simplecov", require: false
  gem "pundit-matchers"
  gem "zonebie"
  gem "yomu"
end

group :development do
  gem "desktop_delivery"
  gem "better_errors"
  gem "meta_request"
  gem "bullet"

  # Please do not use this gem, it create Rails reloader problems
  # gem "binding_of_caller"
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
  gem "rubocop", "~> 0.52.0", require: false
end
