module Dorsale
  module ExpenseGun
    class Category < ActiveRecord::Base
      self.table_name = "dorsale_expense_gun_categories"

      validates :name, presence: true
      validates :vat_deductible, inclusion: {in: [true, false]}
    end
  end
end
