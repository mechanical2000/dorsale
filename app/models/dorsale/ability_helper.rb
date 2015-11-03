module Dorsale
  module AbilityHelper
    def define_dorsale_comment_abilities
      can [:create, :update, :delete], ::Dorsale::Comment
    end

    def define_user_abilities
      can [:list, :create, :update, :delete], User
    end
  end
end
