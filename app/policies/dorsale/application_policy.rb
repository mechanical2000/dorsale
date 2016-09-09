class Dorsale::ApplicationPolicy
  attr_reader :user, :subject

  def initialize(user, subject)
    @user    = user
    @subject = subject
  end

  def policy(subject)
    Pundit.policy(user, subject)
  end

  def policy_scope(subject)
    Pundit.policy_scope(user, subject)
  end

  def self.inherited(klass)
    klass.define_accessor
  end

  def self.define_accessor
    # Dorsale::BillingMachine::InvoicePolicy -> :invoice
    object_type = self.to_s.split("::").last.gsub("Policy", "").underscore.to_sym

    # Avoid user/subject conflict
    object_type = :other_user if object_type == :user

    self.send(:define_method, object_type) { subject }
  end

  private

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError
    end
  end
end
