class AddOriginAndActivityTypeToCustomerVaultPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :dorsale_customer_vault_people, :activity_type_id, :integer
    add_column :dorsale_customer_vault_people, :origin_id, :integer
  end
end
