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
  s.license     = "Nonstandard"

  # Nécessaire pour les factories
  s.test_files  = Dir["{spec,features}/**/*"].reject { |f| f.include?("/dummy") }

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.md", "Rakefile", "README.md", "CHANGELOG.md"]

  s.add_dependency "rails", ">= 4.0.0", "< 99"
  s.add_dependency "agilibox", ">= 1.0.10", "< 99"
  s.add_dependency "virtus", "< 99"
  s.add_dependency "slim-rails", "< 99"
  s.add_dependency "simple_form", "< 99"
  s.add_dependency "coffee-rails", "< 99"
  s.add_dependency "jquery-rails", "< 99"
  s.add_dependency "kaminari", "< 99"
  s.add_dependency "turbolinks", "< 99"
  s.add_dependency "bootstrap-kaminari-views", "< 99"
  s.add_dependency "rails-i18n", "< 99"
  s.add_dependency "pundit", "< 99"
  s.add_dependency "kaminari-i18n", "< 99"
  s.add_dependency "bootstrap-datepicker-rails", "< 99"
  s.add_dependency "carrierwave", "< 99"
  s.add_dependency "aasm", "< 99"
  s.add_dependency "pdf-reader", "< 99"
  s.add_dependency "prawn", "< 99"
  s.add_dependency "prawn-table", "< 99"
  s.add_dependency "ttfunk", "< 1.6.0" # https://github.com/prawnpdf/ttfunk/issues/72
  s.add_dependency "combine_pdf", "< 99"
  s.add_dependency "cocoon", "< 99"
  s.add_dependency "acts-as-taggable-on", ">= 4.0.0", "< 99"
  s.add_dependency "mini_magick", "< 99"
  s.add_dependency "rake", "< 99"
  s.add_dependency "axlsx", "< 99"
  s.add_dependency "zip-zip", "< 99"
  s.add_dependency "nilify_blanks", "< 99"
  s.add_dependency "chartkick", "< 99"
end
