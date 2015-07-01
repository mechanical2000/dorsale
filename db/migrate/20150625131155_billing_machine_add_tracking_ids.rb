class BillingMachineAddTrackingIds < ActiveRecord::Migration
  def change
    add_column :dorsale_billing_machine_invoices,   :tracking_id, :string
    add_column :dorsale_billing_machine_quotations, :tracking_id, :string
  end
end
