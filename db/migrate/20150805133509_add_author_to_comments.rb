class AddAuthorToComments < ActiveRecord::Migration
  def up
    add_column :dorsale_flyboy_task_comments, :author_type, :string

    if column_exists? :dorsale_flyboy_task_comments, :author_id
      Dorsale::Flyboy::TaskComment.where("author_id is not null").update_all(author_type: 'User')
    else
      add_column :dorsale_flyboy_task_comments, :author_id, :integer
    end
  end

  def down
    remove_column :dorsale_flyboy_task_comments, :author_id
    remove_column :dorsale_flyboy_task_comments, :author_type
  end

end
