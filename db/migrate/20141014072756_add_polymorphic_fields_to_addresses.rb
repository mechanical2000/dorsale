class AddPolymorphicFieldsToAddresses < ActiveRecord::Migration
  def change
    add_column :dorsale_addresses, :addressable_id, :integer
    add_column :dorsale_addresses, :addressable_type, :string
  end
end
