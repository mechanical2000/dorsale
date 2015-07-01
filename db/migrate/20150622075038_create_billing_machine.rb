class CreateBillingMachine < ActiveRecord::Migration
  def change
    create_table :dorsale_billing_machine_id_cards do |t|
      t.string   :id_card_name
      t.string   :entity_name
      t.string   :siret
      t.string   :legal_form
      t.integer  :capital
      t.string   :registration_number
      t.string   :intracommunity_vat
      t.string   :address1
      t.string   :address2
      t.string   :zip
      t.string   :city
      t.string   :phone
      t.string   :contact_full_name
      t.string   :contact_phone
      t.string   :contact_address_1
      t.string   :contact_address_2
      t.string   :contact_zip
      t.string   :contact_city
      t.string   :iban
      t.string   :bic_swift
      t.string   :bank_name
      t.string   :bank_address
      t.string   :ape_naf
      t.text     :custom_info_1
      t.text     :custom_info_2
      t.text     :custom_info_3
      t.string   :contact_fax
      t.string   :contact_email
      t.string   :logo
      t.string   :registration_city

      t.timestamps null: false
    end

    create_table :dorsale_billing_machine_payment_terms do |t|
      t.string   :label
      t.timestamps null: false
    end

    create_table :dorsale_billing_machine_invoices do |t|
      t.integer  :customer_id
      t.string   :customer_type
      t.integer  :payment_term_id
      t.integer  :id_card_id

      t.date     :date
      t.string   :label
      t.decimal  :total_duty
      t.decimal  :vat_amount
      t.decimal  :total_all_taxes
      t.decimal  :advance
      t.decimal  :balance
      t.integer  :unique_index
      t.decimal  :vat_rate
      t.boolean  :paid
      t.date     :due_date

      t.timestamps null: false
    end

    add_index :dorsale_billing_machine_invoices, :customer_id
    add_index :dorsale_billing_machine_invoices, :customer_type
    add_index :dorsale_billing_machine_invoices, :id_card_id
    add_index :dorsale_billing_machine_invoices, :payment_term_id

    create_table :dorsale_billing_machine_invoice_lines do |t|
      t.integer  :invoice_id

      t.text     :label
      t.decimal  :quantity
      t.string   :unit
      t.decimal  :unit_price
      t.decimal  :total

      t.timestamps null: false
    end

    add_index :dorsale_billing_machine_invoice_lines, :invoice_id

    create_table :dorsale_billing_machine_quotations do |t|
      t.integer  :customer_id
      t.string   :customer_type
      t.integer  :id_card_id
      t.integer  :payment_term_id

      t.date     :date
      t.string   :label
      t.decimal  :total_duty
      t.decimal  :vat_amount
      t.decimal  :total_all_taxes
      t.integer  :unique_index
      t.decimal  :vat_rate
      t.text     :comments

      t.timestamps null: false
    end

    add_index :dorsale_billing_machine_quotations, :customer_id
    add_index :dorsale_billing_machine_quotations, :customer_type
    add_index :dorsale_billing_machine_quotations, :id_card_id
    add_index :dorsale_billing_machine_quotations, :payment_term_id

    create_table :dorsale_billing_machine_quotation_lines do |t|
      t.integer  :quotation_id

      t.text     :label
      t.decimal  :quantity
      t.string   :unit
      t.decimal  :unit_price
      t.decimal  :total

      t.timestamps null: false
    end

    add_index :dorsale_billing_machine_quotation_lines, :quotation_id

  end
end
