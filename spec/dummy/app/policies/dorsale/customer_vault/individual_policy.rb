class Dorsale::CustomerVault::IndividualPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::IndividualPolicyHelper
  define_dummy_policies!
end
