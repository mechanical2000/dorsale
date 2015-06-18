class RemoveTasksCostAndBudget < ActiveRecord::Migration
  def change
    remove_column :dorsale_flyboy_tasks, :cost
    remove_column :dorsale_flyboy_tasks, :budget
  end
end
