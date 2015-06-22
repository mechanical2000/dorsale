class RenameGoalsToFolders < ActiveRecord::Migration
  def change
    rename_table :dorsale_flyboy_goals, :dorsale_flyboy_folders

    Dorsale::Flyboy::Task.where(taskable_type: "Flyboy::Goal").update_all(taskable_type: Dorsale::Flyboy::Folder)
  end
end
