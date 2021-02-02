class BillingMachineAddPositions < ActiveRecord::Migration[6.0]
  def change
    add_column :dorsale_billing_machine_invoice_lines, :position, :integer, null: false, default: 0
    add_column :dorsale_billing_machine_quotation_lines, :position, :integer, null: false, default: 0
  end
end
