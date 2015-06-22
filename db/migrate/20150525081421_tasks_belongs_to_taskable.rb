class TasksBelongsToTaskable < ActiveRecord::Migration
  def change
    rename_column :dorsale_flyboy_tasks, :goal_id, :taskable_id
    add_column :dorsale_flyboy_tasks, :taskable_type, :string
    Dorsale::Flyboy::Task.update_all(taskable_type: Dorsale::Flyboy::Goal)
  end
end
