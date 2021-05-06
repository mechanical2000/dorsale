module Dorsale::ExpenseGun::ExpensePolicyHelper
  POLICY_METHODS = [
    :list?,
    :create?,
    :read?,
    :update?,
    :copy?,
    :go_to_pending?,
    :go_to_paid?,
    :go_to_canceled?,
  ]

  def go_to_pending?
    return false unless expense.state == "draft"
    super
  end

  def go_to_paid?
    return false unless expense.state == "pending"
    super
  end

  def go_to_canceled?
    return false unless expense.state == "draft"
    super
  end
end
