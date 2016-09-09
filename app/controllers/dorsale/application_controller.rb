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

  private

  def person_policy_scope
    policy_scope(::Dorsale::CustomerVault::Corporation).all +
    policy_scope(::Dorsale::CustomerVault::Individual).all
  end

end
