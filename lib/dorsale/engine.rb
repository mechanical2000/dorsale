require "slim-rails"
require "sass-rails"
require "bootstrap-sass"
require "font-awesome-sass"
require "simple_form"
require "coffee-rails"
require "jquery-rails"
require "kaminari"
require "turbolinks"
require "bootstrap-kaminari-views"
require "bh"
require "rails-i18n"
require "cancan"

require "dorsale/simple_form"
require "dorsale/simple_form_bootstrap"

module Dorsale
  class Engine < ::Rails::Engine
    isolate_namespace Dorsale

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.template_engine :slim
    end

  end
end
