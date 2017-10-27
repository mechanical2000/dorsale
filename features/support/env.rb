ENV["RAILS_ROOT"] ||= File.expand_path("../../../spec/dummy", __FILE__)
require "cucumber/rails"
require "agilibox/cucumber_config"
Agilibox::CucumberConfig.require_all_helpers!
