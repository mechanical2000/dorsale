class CreateCustomerVault < ActiveRecord::Migration
  def change
    create_table :dorsale_customer_vault_corporations do |t|
      t.string   :name
      t.string   :short_name
      t.string   :email
      t.string   :phone
      t.string   :fax
      t.string   :www
      t.string   :legal_form
      t.integer  :capital
      t.string   :immatriculation_number_1
      t.string   :immatriculation_number_2

      t.timestamps null: false
    end

    create_table :dorsale_customer_vault_individuals do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :short_name
      t.string   :email
      t.string   :title
      t.string   :twitter
      t.string   :www
      t.text     :context
      t.string   :phone
      t.string   :fax
      t.string   :mobile

      t.timestamps null: false
    end

    create_table :dorsale_customer_vault_links do |t|
      t.string   :title
      t.integer  :alice_id
      t.string   :alice_type
      t.integer  :bob_id
      t.string   :bob_type

      t.timestamps null: false
    end

    add_index :dorsale_customer_vault_links, :alice_id
    add_index :dorsale_customer_vault_links, :alice_type
    add_index :dorsale_customer_vault_links, :bob_id
    add_index :dorsale_customer_vault_links, :bob_type
  end
end
