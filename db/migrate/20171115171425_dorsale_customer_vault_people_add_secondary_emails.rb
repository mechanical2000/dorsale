class DorsaleCustomerVaultPeopleAddSecondaryEmails < ActiveRecord::Migration[5.0]
  def change
    change_table :dorsale_customer_vault_people do |t|
      t.string :secondary_emails, array: true, default: [], null: false
    end

    add_index :dorsale_customer_vault_people, :secondary_emails, using: "gin"
  end
end
