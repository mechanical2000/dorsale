module Dorsale
    module AbilityHelper
      def define_dorsale_comment_abilities
        can [:create, :update, :delete], ::Dorsale::Comment
      end
    end
end
