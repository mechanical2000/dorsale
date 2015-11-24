class AddIsActiveToUsers < ActiveRecord::Migration
  def change
    return if table_exists?(:users)
    return if column_exists?(:users, :active)
    return if column_exists?(:users, :is_active)

    add_column :users, :is_active, :boolean
  end
end
