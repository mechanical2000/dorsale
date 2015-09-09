class AddPolymorphicUsersToComments < ActiveRecord::Migration
  def up
    add_column :dorsale_comments, :author_type, :string
    Dorsale::Comment.where("author_id is not null").update_all(author_type: 'User')
    rename_column :dorsale_comments, :user_id, :author_id
  end

  def down
    rename_column :dorsale_comments, :author_id, :user_id
    remove_column :dorsale_comments, :author_type
  end

end
