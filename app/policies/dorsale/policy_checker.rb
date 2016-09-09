class Dorsale::PolicyChecker
  def errors
    @errors ||= []
  end

  def check!
    errors.clear

    check_policy! "Dorsale::Alexandrie::AttachmentPolicy"
    check_policy! "Dorsale::BillingMachine::IdCardPolicy"
    check_policy! "Dorsale::BillingMachine::InvoicePolicy"
    check_policy! "Dorsale::BillingMachine::PaymentTermPolicy"
    check_policy! "Dorsale::BillingMachine::QuotationPolicy"
    check_policy! "Dorsale::CommentPolicy"
    check_policy! "Dorsale::CustomerVault::PersonPolicy"
    check_policy! "Dorsale::ExpenseGun::CategoryPolicy"
    check_policy! "Dorsale::ExpenseGun::ExpensePolicy"
    check_policy! "Dorsale::Flyboy::FolderPolicy"
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
    begin
     policy_klass = policy.constantize
    rescue NameError
      errors << "#{policy} does not exist"
    end

    helper_klass = "#{policy}Helper".constantize

    unless policy_klass < helper_klass
      errors << "#{policy_klass} does not prepend #{helper_klass}"
      return
    end

    helper_klass::POLICY_METHODS.each do |method|
      unless policy_klass.public_instance_methods.include?(method)
        errors << "#{policy_klass}##{method} is not defined"
      end
    end
  end

end
