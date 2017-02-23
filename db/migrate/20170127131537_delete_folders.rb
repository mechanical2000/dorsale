class DeleteFolders < ActiveRecord::Migration[5.0]
  def change
    # Comment this migration or only this line to keep or delete folders
    raise "Hi ! Do you want to delete folders ?"
    drop_table :dorsale_flyboy_folders
    Dorsale::Flyboy::Task
      .where(taskable_type: "Dorsale::Flyboy::Folder")
      .update_all(taskable_type: nil, taskable_id: nil)
  end
end
