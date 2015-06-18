class CreateFlyboyTasks < ActiveRecord::Migration
  def change
    create_table :flyboy_tasks do |t|
      t.integer :goal_id
      t.string  :title
      t.text    :description
      t.integer :progress, default: 0
      t.boolean :done
      t.date    :term
      t.date    :reminder
      t.integer :cost
      t.integer :budget
      t.timestamps null: false
    end
  end
end
