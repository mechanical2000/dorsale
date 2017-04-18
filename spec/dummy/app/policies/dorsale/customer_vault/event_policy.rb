class Dorsale::CustomerVault::EventPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::EventPolicyHelper
  define_dummy_policies!
end
