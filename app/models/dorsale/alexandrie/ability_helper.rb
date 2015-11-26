module Dorsale
  module Alexandrie
    module AbilityHelper
      def define_alexandrie_abilities
        can [:create, :update, :delete], ::Dorsale::Alexandrie::Attachment
      end
    end
  end
end
