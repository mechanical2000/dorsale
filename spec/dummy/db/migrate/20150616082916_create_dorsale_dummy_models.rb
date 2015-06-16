class CreateDorsaleDummyModels < ActiveRecord::Migration
  def change
    create_table :dummy_models do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
