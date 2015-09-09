class AddOwnersToTasks < ActiveRecord::Migration
  def up
    add_column :dorsale_flyboy_tasks, :owner_type, :string

    if column_exists? :dorsale_flyboy_tasks, :owner_id
      Dorsale::Flyboy::Task.where("owner_id is not null").update_all(owner_type: 'User')
    else
      add_column :dorsale_flyboy_tasks, :owner_id, :integer
    end
  end

  def down
    remove_column :dorsale_flyboy_tasks, :owner_id
    remove_column :dorsale_flyboy_tasks, :owner_type
  end

end
