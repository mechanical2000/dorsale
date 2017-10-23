class CustomerVaultEventsAddContactType < ActiveRecord::Migration[5.0]
  def change
    add_column :dorsale_customer_vault_events, :contact_type, :string
  end
end
