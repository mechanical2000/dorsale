ENV["RAILS_ROOT"] ||= File.expand_path("../../../spec/dummy", __FILE__)
require "cucumber/rails"
require "agilibox/cucumber_config"
def Zonebie.set_random_timezone
  # https://github.com/agilidee/dorsale/issues/273
end
Agilibox::CucumberConfig.require_all_helpers!
