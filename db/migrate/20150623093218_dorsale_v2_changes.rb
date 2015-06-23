class DorsaleV2Changes < ActiveRecord::Migration
  def change
    # add_column :customer_vault_individuals, :short_name, :string
    # add_column :customer_vault_corporations, :short_name, :string

    # rename_table :flyboy_goals, :dorsale_flyboy_folders
    # rename_table :flyboy_tasks, :dorsale_flyboy_tasks
    # rename_table :flyboy_task_commentss, :dorsale_flyboy_task_comments
    # add_column :dorsale_flyboy_folders, :folderable_id, :integer
    # add_column :dorsale_flyboy_folders, :folderable_type, :string

    # rename_table :invoices, :dorsale_billing_machine_invoices
    # rename_table :quotations, :dorsale_billing_machine_quotations
    # rename_table :id_cards, :dorsale_billing_machine_id_cards
    # add_column :dorsale_billing_machine_id_cards, :logo, :string
    # # TODO : Logo migration
    # remove_column :dorsale_billing_machine_id_cards, :logo_file_name
    # remove_column :dorsale_billing_machine_id_cards, :logo_content_type
    # remove_column :dorsale_billing_machine_id_cards, :logo_file_size
    # remove_column :dorsale_billing_machine_id_cards, :logo_updated_at
    # # TODO : Quotation attachments migration
    # remove_table :documents
  end
end
