class DorsaleBillingMachineInvoicesAddComments < ActiveRecord::Migration
  def change
    add_column :dorsale_billing_machine_invoices, :comments, :text
  end
end
