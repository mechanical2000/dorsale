class CreateFlyboy < ActiveRecord::Migration
  def change
    create_table :dorsale_flyboy_folders do |t|
      t.integer  :folderable_id
      t.string   :folderable_type

      t.string   :name
      t.text     :description
      t.integer  :progress
      t.string   :status
      t.string   :tracking
      t.integer  :version

      t.timestamps null: false
    end

    add_index :dorsale_flyboy_folders, :folderable_id
    add_index :dorsale_flyboy_folders, :folderable_type

    create_table :dorsale_flyboy_task_comments do |t|
      t.integer  :task_id

      t.datetime :date
      t.text     :description
      t.integer  :progress

      t.timestamps null: false
    end

    add_index :dorsale_flyboy_task_comments, :task_id

    create_table :dorsale_flyboy_tasks do |t|
      t.integer  :taskable_id
      t.string   :taskable_type

      t.string   :name
      t.text     :description
      t.integer  :progress
      t.boolean  :done
      t.date     :term
      t.date     :reminder

      t.timestamps null: false
    end

    add_index :dorsale_flyboy_tasks, :taskable_id
    add_index :dorsale_flyboy_tasks, :taskable_type

  end
end
