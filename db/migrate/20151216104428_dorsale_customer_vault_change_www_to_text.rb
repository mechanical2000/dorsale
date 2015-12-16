class DorsaleCustomerVaultChangeWwwToText < ActiveRecord::Migration
  def change
    change_column :dorsale_customer_vault_corporations, :www, :text
    change_column :dorsale_customer_vault_corporations, :email, :text
    change_column :dorsale_customer_vault_individuals, :www, :text
    change_column :dorsale_customer_vault_individuals, :email, :text
  end
end
