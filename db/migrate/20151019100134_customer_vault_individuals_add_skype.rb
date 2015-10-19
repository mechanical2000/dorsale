class CustomerVaultIndividualsAddSkype < ActiveRecord::Migration
  def change
    add_column :dorsale_customer_vault_individuals, :skype, :string
  end
end
