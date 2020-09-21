class Dorsale::ApplicationPolicy
  attr_reader :user, :subject

  def initialize(user, subject)
    @user    = user
    @subject = subject
  end

  def record
    subject
  end

  def policy(subject)
    Pundit.policy(user, subject)
  end

  def policy_scope(subject)
    Pundit.policy_scope(user, subject)
  end

  def self.inherited(klass)
    super(klass)
    klass.define_subject_accessor!
  end

  def self.define_subject_accessor!
    # Dorsale::BillingMachine::InvoicePolicy -> :invoice
    object_type = to_s.demodulize.gsub("Policy", "").underscore.to_sym

    # Avoid user/subject conflict
    object_type = :other_user if object_type == :user

    send(:define_method, object_type) { subject }
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end
  end
end
