module Dorsale
  module ExpenseGun
    module AbilityHelper
      def define_dorsale_expense_gun_abilities
        can [:list, :create, :read, :update, :submit , :accept, :refuse, :cancel], ::Dorsale::ExpenseGun::Expense
        can [:list, :create, :update], ::Dorsale::ExpenseGun::Category
      end
    end
  end
end
