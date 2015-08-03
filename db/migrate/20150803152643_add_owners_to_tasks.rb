class AddOwnersToTasks < ActiveRecord::Migration
  def change
    add_column :dorsale_flyboy_tasks, :owner_id, :integer
    add_column :dorsale_flyboy_tasks, :owner_type, :string
  end
end
