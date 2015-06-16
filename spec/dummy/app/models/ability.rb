class Ability
  include CanCan::Ability

  def initialize(*args)
    can :manage, :all
  end
end
