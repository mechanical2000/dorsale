module Dorsale
  class ApplicationMailer < ActionMailer::Base
    DEFAULT_FROM = "contact@example.org"
    default from: DEFAULT_FROM

    helper Dorsale::AllHelpers
  end
end
