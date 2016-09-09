class Dorsale::CustomerVault::CorporationPolicy < Dorsale::ApplicationPolicy
  prepend Dorsale::CustomerVault::CorporationPolicyHelper
  define_dummy_policies!
end
