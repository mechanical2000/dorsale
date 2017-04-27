class Dorsale::CustomerVault::OriginPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::OriginPolicyHelper
  define_dummy_policies!
end
