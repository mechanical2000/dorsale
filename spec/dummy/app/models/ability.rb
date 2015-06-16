class Ability
  include CanCan::Ability
  include ::Dorsale::Alexandrie::AbilityHelper
  include ::Dorsale::AbilityHelper

  def initialize(*)
    define_alexandrie_abilities
    define_dorsale_comment_abilities
  end
end
