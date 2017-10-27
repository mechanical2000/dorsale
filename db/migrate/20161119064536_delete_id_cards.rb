class DeleteIdCards < ActiveRecord::Migration[5.0]
  def change
    # Comment this migration or only this line to keep or delete id cards
    raise "Hi ! Do you want to delete id cards ?"
    drop_table :dorsale_billing_machine_id_cards
    remove_column :dorsale_billing_machine_invoices, :id_card_id
    remove_column :dorsale_billing_machine_quotations, :id_card_id
  end
end
