$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dorsale/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dorsale"
  s.version     = Dorsale::VERSION
  s.authors     = ["agilidée"]
  s.email       = ["contact@agilidee.com"]
  s.homepage    = "https://github.com/agilidee/dorsale"
  s.summary     = "Modular ERP made with Ruby on Rails"
  s.description = "Run your own business."
  s.test_files  = Dir["{spec,features}/**/*"].reject { |f| f.include?("/dummy") }

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.md", "Rakefile", "README.md", "CHANGELOG.md"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "agilibox", ">= 1.0.10"
  s.add_dependency "virtus"
  s.add_dependency "slim-rails"
  s.add_dependency "simple_form"
  s.add_dependency "coffee-rails"
  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  s.add_dependency "turbolinks"
  s.add_dependency "bootstrap-kaminari-views"
  s.add_dependency "rails-i18n"
  s.add_dependency "pundit"
  s.add_dependency "kaminari-i18n"
  s.add_dependency "bootstrap-datepicker-rails"
  s.add_dependency "carrierwave"
  s.add_dependency "aasm"
  s.add_dependency "pdf-reader"
  s.add_dependency "prawn"
  s.add_dependency "prawn-table"
  s.add_dependency "combine_pdf"
  s.add_dependency "cocoon"
  s.add_dependency "acts-as-taggable-on", ">= 4.0.0"
  s.add_dependency "mini_magick"
  s.add_dependency "rake"
  s.add_dependency "axlsx"
  s.add_dependency "zip-zip"
  s.add_dependency "nilify_blanks"
  s.add_dependency "chartkick"
end
