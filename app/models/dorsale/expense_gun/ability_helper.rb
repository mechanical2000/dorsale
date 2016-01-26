module Dorsale
  module ExpenseGun
    module AbilityHelper
      def define_dorsale_expense_gun_abilities
        can [:list, :create, :show, :edit, :submit , :accept, :refuse, :cancel], ::Dorsale::ExpenseGun::Expense
      end
    end
  end
end
