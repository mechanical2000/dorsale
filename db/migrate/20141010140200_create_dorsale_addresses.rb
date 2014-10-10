class CreateDorsaleAddresses < ActiveRecord::Migration
  def change
    create_table :dorsale_addresses do |t|
      t.string :street
      t.string :street_bis
      t.string :city
      t.string :zip
      t.string :country

      t.timestamps
    end
  end
end
