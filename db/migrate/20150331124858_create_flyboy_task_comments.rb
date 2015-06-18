class CreateFlyboyTaskComments < ActiveRecord::Migration
  def change
    create_table :flyboy_task_comments do |t|
      t.integer  :task_id
      t.datetime :date
      t.text     :description
      t.integer  :progress
      t.timestamps null: false
    end
  end
end
