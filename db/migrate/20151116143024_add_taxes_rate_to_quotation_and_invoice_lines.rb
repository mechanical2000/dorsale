class AddTaxesRateToQuotationAndInvoiceLines < ActiveRecord::Migration
  def change

    rename_column :dorsale_billing_machine_invoices, :total_duty, :total_excluding_taxes
    rename_column :dorsale_billing_machine_invoices, :total_all_taxes, :total_including_taxes
    rename_column :dorsale_billing_machine_quotations, :total_duty, :total_excluding_taxes
    rename_column :dorsale_billing_machine_quotations, :total_all_taxes, :total_including_taxes
    add_column :dorsale_billing_machine_quotation_lines, :vat_rate, :decimal
    add_column :dorsale_billing_machine_invoice_lines, :vat_rate, :decimal

    Dorsale::BillingMachine::Invoice.all.each do |invoice|
      invoice.lines.each do |line|
        line.vat_rate = invoice.vat_rate
        line.save!
      end
     invoice.save!
    end

    Dorsale::BillingMachine::Quotation.all.each do |quotation|
      quotation.lines.each do |line|
        line.vat_rate = quotation.vat_rate
        line.save!
      end
     quotation.save!
    end

    remove_column :dorsale_billing_machine_quotations, :vat_rate
    remove_column :dorsale_billing_machine_invoices, :vat_rate


  end
end
