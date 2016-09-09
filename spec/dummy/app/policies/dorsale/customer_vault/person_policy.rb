class Dorsale::CustomerVault::PersonPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::PersonPolicyHelper
  define_dummy_policies!

  class Scope < Scope
    def resolve
      Pundit.policy_scope(user, ::Dorsale::CustomerVault::Corporation) + Pundit.policy_scope(user, ::Dorsale::CustomerVault::Individual)
    end
  end
end
