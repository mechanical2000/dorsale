require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "dorsale"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.autoloader = :classic

    config.time_zone = "Paris"
    config.i18n.default_locale = :fr
    config.active_job.queue_adapter = :inline
    config.active_record.belongs_to_required_by_default = false
  end
end
