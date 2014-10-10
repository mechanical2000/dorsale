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
