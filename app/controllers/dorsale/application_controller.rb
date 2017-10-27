class Dorsale::ApplicationController < ::ApplicationController
  include Pundit
  include Agilibox::BackUrlConcern
  include Agilibox::SortingHelper

  after_action :verify_authorized
  after_action :verify_policy_scoped

  layout -> {
    if request.xhr?
      false
    else
      "application"
    end
  }

  def filters_jar
    cookies
  end

  def model
    raise NotImplementedError
  end

  helper_method :model
  helper_method :filters_jar

  def scope
    policy_scope(model)
  end

  helper_method :scope
end
