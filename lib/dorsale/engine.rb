require "slim-rails"
require "simple_form"
require "coffee-rails"
require "jquery-rails"
require "kaminari"
require "turbolinks"
require "bootstrap-kaminari-views"
require "bootstrap-datepicker-rails"
require "cocoon"

require "rails-i18n"
require "pundit"
require "awesome_print"
require "kaminari-i18n"
require "carrierwave"
require "aasm"
require "pdf/reader"
require "prawn"
require "prawn/table"
require "combine_pdf"
require "nilify_blanks"
require "chartkick"
require "axlsx"

require "agilibox"

if Rails.env.test? || Rails.env.development?
  require "pry"
  require "factory_bot_rails"
  require "factory_bot"
end

require "acts-as-taggable-on"

module Dorsale
  class Engine < ::Rails::Engine
    isolate_namespace Dorsale

    initializer "factory_bot" do
      if Rails.env.test? || Rails.env.development?
        FactoryBot.definition_file_paths.unshift Dorsale::Engine.root.join("spec/factories/").to_s
      end
    end

    initializer "check_rails_version" do
      if Rails.version < "5.0.0"
        warn "Dorsale 3 supports only Rails 5, please update Rails."
      end
    end

    initializer "check_pundit_policies" do
      Dorsale::PolicyChecker.check! if Rails.env.test? || Rails.env.development?
    end

    initializer "assets" do
      Rails.application.config.assets.precompile += %w(
        dorsale/avatar.png
      )
    end

    initializer "simple_form" do
      require "dorsale/simple_form"
      require "dorsale/simple_form_bootstrap"
    end

    Mime::Type.register "application/vnd.ms-excel", :xls
    Mime::Type.register "application/vnd.ms-excel", :xlsx
  end
end

require_relative "file_loader"
