module Dorsale
  module ExpenseGun
    class Category < ActiveRecord::Base
      self.table_name = "dorsale_expense_gun_categories"
      validates :name, presence: true
    end
  end
end