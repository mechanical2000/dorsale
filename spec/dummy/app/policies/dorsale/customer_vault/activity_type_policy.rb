class Dorsale::CustomerVault::ActivityTypePolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::ActivityTypePolicyHelper
  define_dummy_policies!
end
