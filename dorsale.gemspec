$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dorsale/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dorsale"
  s.version     = Dorsale::VERSION
  s.authors     = ["AGILiDEE"]
  s.email       = ["contact@agilidee.com"]
  s.homepage    = "https://github.com/AGILiDEE/dorsale"
  s.summary     = "Modular ERP made with Ruby on Rails"
  s.description = "Run your own business."
  s.test_files = Dir["spec/**/*"]
  
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.10"
  s.add_dependency "slim"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "slim-rails"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
