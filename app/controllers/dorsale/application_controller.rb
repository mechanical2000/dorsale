class Dorsale::ApplicationController < ::ApplicationController
  include Pundit
  include Dorsale::BackUrlConcern

  after_action :verify_authorized

  def current_user_scope
    @current_user_scope ||= ::Dorsale::UserScope.new(current_user)
  end

  layout -> {
    if request.xhr?
      false
    else
      "application"
    end
  }

end
