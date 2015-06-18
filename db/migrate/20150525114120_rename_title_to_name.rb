class RenameTitleToName < ActiveRecord::Migration
  def change
    rename_column :dorsale_flyboy_goals, :title, :name
    rename_column :dorsale_flyboy_tasks, :title, :name
  end
end
