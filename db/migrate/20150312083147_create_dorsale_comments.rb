class CreateDorsaleComments < ActiveRecord::Migration
  def change
    create_table :dorsale_comments do |t|
      t.integer :user_id
      t.string :user_type
      
      t.integer :commentable_id
      t.string :commentable_type
      
      t.text :text
      
      t.timestamps null: false
    end
  end
end
