class CreateDorsaleCustomerVaultActivityTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :dorsale_customer_vault_activity_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
