class Dorsale::BillingMachine::ApplicationController < ::Dorsale::ApplicationController
  before_action :set_common_variables

  private

  def euros(*)
    raise "#euros is not available in BillingMachine, please use #bm_currency instead"
  end

  helper_method :euros

  def set_common_variables
    @payment_terms ||= policy_scope(::Dorsale::BillingMachine::PaymentTerm)
    @people        ||= policy_scope(::Dorsale::CustomerVault::Person)
  end

  def email_permitted_params
    [
      :to,
      :subject,
      :body,
    ]
  end

  def email_params
    params.fetch(:email, {})
      .permit(email_permitted_params)
      .merge(current_user: current_user)
  end
end
