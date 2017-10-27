class Dorsale::PolicyChecker
  def errors
    @errors ||= []
  end

  def check!
    errors.clear

    check_policy! "Dorsale::Alexandrie::AttachmentPolicy"
    check_policy! "Dorsale::Alexandrie::AttachmentTypePolicy"
    check_policy! "Dorsale::BillingMachine::InvoicePolicy"
    check_policy! "Dorsale::BillingMachine::PaymentTermPolicy"
    check_policy! "Dorsale::BillingMachine::QuotationPolicy"
    check_policy! "Dorsale::CommentPolicy"
    check_policy! "Dorsale::CustomerVault::EventPolicy"
    check_policy! "Dorsale::CustomerVault::PersonPolicy"
    check_policy! "Dorsale::CustomerVault::LinkPolicy"
    check_policy! "Dorsale::CustomerVault::OriginPolicy"
    check_policy! "Dorsale::CustomerVault::ActivityTypePolicy"
    check_policy! "Dorsale::ExpenseGun::CategoryPolicy"
    check_policy! "Dorsale::ExpenseGun::ExpensePolicy"
    check_policy! "Dorsale::Flyboy::TaskPolicy"
    check_policy! "UserPolicy"

    errors.each do |error|
      warn error
    end

    errors.empty?
  end

  def self.check!
    new.check!
  end

  private

  def check_policy!(policy)
    if (policy_klass = policy.safe_constantize).nil?
      errors << "#{policy} does not exist"
      return
    end

    if (helper_klass = "#{policy}Helper".safe_constantize).nil?
      errors << "#{policy}Helper does not exist"
      return
    end

    if (scope_klass = "#{policy}::Scope".constantize).nil?
      errors << "#{policy}::Scope does not exist"
      return
    end

    if scope_klass.public_instance_methods.exclude?(:resolve)
      errors << "#{policy}::Scope#resolve is not defined"
      return
    end

    unless policy_klass < helper_klass
      errors << "#{policy_klass} does not prepend #{helper_klass}"
      return
    end

    helper_klass::POLICY_METHODS.each do |method|
      if policy_klass.public_instance_methods(false).exclude?(method)
        errors << "#{policy_klass}##{method} is not defined"
      end
    end
  end # def check_policy
end
