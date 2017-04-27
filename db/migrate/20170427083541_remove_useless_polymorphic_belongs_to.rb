class RemoveUselessPolymorphicBelongsTo < ActiveRecord::Migration[5.0]
  def change
    raise "Hi ! Do you really want to delete these columns ?"
    remove_column :dorsale_comments,               :author_type
    remove_column :dorsale_alexandrie_attachments, :sender_type
    remove_column :dorsale_flyboy_tasks,           :owner_type
    remove_column :dorsale_flyboy_task_comments,   :author_type
  end
end
