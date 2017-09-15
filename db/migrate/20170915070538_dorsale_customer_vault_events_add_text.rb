class DorsaleCustomerVaultEventsAddText < ActiveRecord::Migration[5.0]
  def change
    add_column :dorsale_customer_vault_events, :text, :text
    model = Dorsale::CustomerVault::Event
    model.where(action: "create").update_all(text: model.t("text.create"))
    model.where(action: "update").update_all(text: model.t("text.update"))
  end
end
