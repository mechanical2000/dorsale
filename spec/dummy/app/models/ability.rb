class Ability
  include CanCan::Ability
  include ::Dorsale::Alexandrie::AbilityHelper

  def initialize(*)
    define_alexandrie_abilities
  end
end
