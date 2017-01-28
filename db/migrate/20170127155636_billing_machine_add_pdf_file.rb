class BillingMachineAddPdfFile < ActiveRecord::Migration[5.0]
  def change
    add_column :dorsale_billing_machine_invoices,   :pdf_file, :string
    add_column :dorsale_billing_machine_quotations, :pdf_file, :string

    Dorsale::ApplicationRecord.reset_column_information

    Dorsale::BillingMachine::Invoice.all.each do |invoice|
      Dorsale::BillingMachine::PdfFileGenerator.(invoice)
    end

    Dorsale::BillingMachine::Quotation.all.each do |quotation|
      Dorsale::BillingMachine::PdfFileGenerator.(quotation)
    end
  end
end
