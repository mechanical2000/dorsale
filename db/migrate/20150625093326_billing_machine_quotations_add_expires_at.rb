class BillingMachineQuotationsAddExpiresAt < ActiveRecord::Migration
  def change
    add_column :dorsale_billing_machine_quotations, :expires_at, :date
  end
end
