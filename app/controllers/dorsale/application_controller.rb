module Dorsale
  class ApplicationController < ::ApplicationController
    def current_user_scope
      @current_user_scope ||= UserScope.new(current_user)
    end
  end
end
