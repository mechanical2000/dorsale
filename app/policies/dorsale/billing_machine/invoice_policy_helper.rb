module Dorsale::BillingMachine::InvoicePolicyHelper
  POLICY_METHODS = [
    :list?,
    :export?,
    :create?,
    :read?,
    :update?,
    :download?,
    :copy?,
    :email?,
  ]

  def email?
    return false if invoice.customer.try(:email).nil?
    super
  end
end
