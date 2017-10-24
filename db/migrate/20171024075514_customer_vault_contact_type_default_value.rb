class CustomerVaultContactTypeDefaultValue < ActiveRecord::Migration[5.0]
  def change
    Dorsale::CustomerVault::Event.where(contact_type: nil).update_all(contact_type: "contact")
  end
end
