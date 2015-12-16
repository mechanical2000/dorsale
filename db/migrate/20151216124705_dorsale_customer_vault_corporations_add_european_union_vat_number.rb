class DorsaleCustomerVaultCorporationsAddEuropeanUnionVatNumber < ActiveRecord::Migration
  def change
    add_column :dorsale_customer_vault_corporations, :european_union_vat_number, :string
  end
end
