require "slim-rails"
require "sass-rails"
require "bootstrap-sass"
require "bh"
require "font-awesome-sass"
require "simple_form"
require "coffee-rails"
require "jquery-rails"
require "kaminari"
require "turbolinks"
require "bootstrap-kaminari-views"
require "bootstrap-datepicker-rails"
require "cocoon"
require "selectize-rails"

require "rails-i18n"
require "cancan"
require "awesome_print"
require "kaminari-i18n"
require "carrierwave"
require "aasm"
require "handles_sortable_columns"
require "csv"
require "pdf/reader"
require "prawn"
require "prawn/table"
require "combine_pdf"

require "dorsale/file_loader"
require "dorsale/polymorphic_id"
require "dorsale/simple_form"
require "dorsale/simple_form_bootstrap"
require "dorsale/model_i18n"
require "dorsale/model_to_s"
require "dorsale/alexandrie/prawn"

require "acts-as-taggable-on"
require "active_record_comma_type_cast"

module Dorsale
  class Engine < ::Rails::Engine
    isolate_namespace Dorsale

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.template_engine :slim
    end

    Mime::Type.register "application/vnd.ms-excel", :xls
  end
end
