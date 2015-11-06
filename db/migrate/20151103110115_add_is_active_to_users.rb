class AddIsActiveToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean if table_exists?(:users)
  end
end
