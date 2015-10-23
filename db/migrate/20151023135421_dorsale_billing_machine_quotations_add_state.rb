class DorsaleBillingMachineQuotationsAddState < ActiveRecord::Migration
  def change
    add_column :dorsale_billing_machine_quotations, :state, :string
    Dorsale::BillingMachine::Quotation.update_all(state: "pending")
  end
end
