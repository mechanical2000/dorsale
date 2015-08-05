class AddPolymorphicUsersToComments < ActiveRecord::Migration
  def up
    add_column :dorsale_comments, :author_type, :string
    Dorsale::Comment.update_all(author_type: 'User')
    rename_column :dorsale_comments, :user_id, :author_id
  end

  def down
    remove_column :dorsale_comments, :author_id
    remove_column :dorsale_comments, :author_type
  end

end
