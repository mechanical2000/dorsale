class BillingMachineAddMissingUniqueIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :dorsale_billing_machine_invoices, :unique_index, unique: true
    add_index :dorsale_billing_machine_quotations, :unique_index, unique: true
  end
end
