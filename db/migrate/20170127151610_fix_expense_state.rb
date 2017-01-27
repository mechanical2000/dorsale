class FixExpenseState < ActiveRecord::Migration[5.0]
  def change
    Dorsale::ExpenseGun::Expense.where(state: "submited").update_all(state: "submitted")
    Dorsale::ExpenseGun::Expense.where(state: "new").update_all(state: "draft")
  end
end
