class AddUserOnExpenseGunExpense < ActiveRecord::Migration
  def change
    add_column :dorsale_expense_gun_expenses, :user_id, :integer
  end
end
