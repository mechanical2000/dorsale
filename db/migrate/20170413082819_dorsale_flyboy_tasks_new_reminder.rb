class DorsaleFlyboyTasksNewReminder < ActiveRecord::Migration[5.0]
  def change
    rename_column :dorsale_flyboy_tasks, :reminder, :reminder_date
    add_column :dorsale_flyboy_tasks, :reminder_type, :string
    add_column :dorsale_flyboy_tasks, :reminder_duration, :integer
    add_column :dorsale_flyboy_tasks, :reminder_unit, :string
    Dorsale::Flyboy::Task.update_all(reminder_type: "custom")
  end
end
