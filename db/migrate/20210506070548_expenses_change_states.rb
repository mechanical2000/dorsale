class ExpensesChangeStates < ActiveRecord::Migration[6.1]
  def change
    Dorsale::ExpenseGun::Expense.where(state: "submitted").update_all(state: "pending")
    Dorsale::ExpenseGun::Expense.where(state: "accepted").update_all(state: "paid")
    Dorsale::ExpenseGun::Expense.where(state: "refused").update_all(state: "canceled")
  end
end
