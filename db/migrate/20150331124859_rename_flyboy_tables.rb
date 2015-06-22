class RenameFlyboyTables < ActiveRecord::Migration
  def change
    rename_table :flyboy_goals, :dorsale_flyboy_goals
    rename_table :flyboy_tasks, :dorsale_flyboy_tasks
    rename_table :flyboy_task_comments, :dorsale_flyboy_task_comments
  end
end
