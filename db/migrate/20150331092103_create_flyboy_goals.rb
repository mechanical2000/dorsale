class CreateFlyboyGoals < ActiveRecord::Migration
  def change
    create_table :flyboy_goals do |t|
      t.string  :title
      t.text    :description
      t.integer :status
      t.string  :tracking
      t.integer :version
      t.timestamps null: false
    end
  end
end
