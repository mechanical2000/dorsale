module Dorsale
  begin
    ApplicationMailer = Class.new(::ApplicationMailer)
  rescue NameError
    ApplicationMailer = Class.new(::ActionMailer::Base)
  end

  class ApplicationMailer
    helper Dorsale::AllHelpers
  end
end
