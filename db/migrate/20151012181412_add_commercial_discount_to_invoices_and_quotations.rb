class AddCommercialDiscountToInvoicesAndQuotations < ActiveRecord::Migration
  def change
    add_column :dorsale_billing_machine_quotations, :commercial_discount, :decimal
    add_column :dorsale_billing_machine_invoices, :commercial_discount, :decimal
  end

  def down
    remove_column :dorsale_billing_machine_quotations, :commercial_discount
    remove_column :dorsale_billing_machine_invoices, :commercial_discount
  end

end
