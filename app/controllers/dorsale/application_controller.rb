class Dorsale::ApplicationController < ::ApplicationController
  include Pundit
  include Dorsale::BackUrlConcern

  after_action :verify_authorized
  after_action :verify_policy_scoped

  layout -> {
    if request.xhr?
      false
    else
      "application"
    end
  }

  def model
    raise NotImplementedError
  end

  helper_method :model

  def scope
    policy_scope(model)
  end

  helper_method :scope

end
