class DorsaleAddMissingIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :dorsale_customer_vault_people, :old_id
    add_index :dorsale_expense_gun_expenses, :user_id
    add_index :dorsale_addresses, :addressable_id
    add_index :dorsale_addresses, :addressable_type
    add_index :dorsale_alexandrie_attachments, :attachable_id
    add_index :dorsale_alexandrie_attachments, :attachable_type
    add_index :dorsale_alexandrie_attachments, :sender_id
    add_index :dorsale_alexandrie_attachments, :sender_type
    add_index :dorsale_billing_machine_invoices, :tracking_id
    add_index :dorsale_billing_machine_quotations, :tracking_id
    add_index :dorsale_comments, :author_id
    add_index :dorsale_comments, :user_type
    add_index :dorsale_comments, :commentable_id
    add_index :dorsale_comments, :commentable_type
    add_index :dorsale_comments, :author_type
    add_index :dorsale_customer_vault_links, :alice_id
    add_index :dorsale_customer_vault_links, :bob_id
    add_index :dorsale_flyboy_task_comments, :author_type
    add_index :dorsale_flyboy_task_comments, :author_id
    add_index :dorsale_flyboy_tasks, :owner_type
    add_index :dorsale_flyboy_tasks, :owner_id
  end
end
