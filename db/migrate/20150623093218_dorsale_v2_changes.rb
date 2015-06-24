class DorsaleV2Changes < ActiveRecord::Migration
  def change
    return # Remove return and comment inutile migrations

    rename_table :customer_vault_corporations, :dorsale_customer_vault_corporations
    rename_table :customer_vault_individuals, :dorsale_customer_vault_individuals
    rename_table :customer_vault_links, :dorsale_customer_vault_links

    # Short name needed by billing machine
    add_column :dorsale_customer_vault_individuals, :short_name, :string
    add_column :dorsale_customer_vault_corporations, :short_name, :string

    # Rename Flyboy tables
    rename_table :flyboy_goals, :dorsale_flyboy_folders
    rename_table :flyboy_tasks, :dorsale_flyboy_tasks
    rename_table :flyboy_task_comments, :dorsale_flyboy_task_comments

    # Add Flyboy folderable
    add_column :dorsale_flyboy_folders, :folderable_id, :integer
    add_column :dorsale_flyboy_folders, :folderable_type, :string
    Dorsale::Flyboy::Task.where(taskable_type: "Flyboy::Goal").update_all(taskable_type: "Dorsale::Flyboy::Folder")

    # Rename BillingMachine tables
    rename_table :invoices, :dorsale_billing_machine_invoices
    rename_table :quotations, :dorsale_billing_machine_quotations
    rename_table :id_cards, :dorsale_billing_machine_id_cards

    # BillingMachine IdCard logo migration
    rename_column :dorsale_billing_machine_id_cards, :logo_file_name, :logo
    # TODO : Rename/move uploads folder
    remove_column :dorsale_billing_machine_id_cards, :logo_content_type
    remove_column :dorsale_billing_machine_id_cards, :logo_file_size
    remove_column :dorsale_billing_machine_id_cards, :logo_updated_at

    # TODO : Migration old quotation documents to Alexandrie
    remove_table :documents
  end
end
