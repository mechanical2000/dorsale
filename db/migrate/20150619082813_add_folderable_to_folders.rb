class AddFolderableToFolders < ActiveRecord::Migration
  def change
    add_column :dorsale_flyboy_folders, :folderable_id, :integer
    add_column :dorsale_flyboy_folders, :folderable_type, :string
  end
end
