module Dorsale
  module CustomerVault
    module AbilityHelper
      def define_dorsale_customer_vault_abilities
        can [:list, :create, :read, :update, :delete], ::Dorsale::CustomerVault::Person
      end
    end
  end
end
