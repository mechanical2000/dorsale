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

    Dorsale::Flyboy::Task
      .where(taskable_type: "Flyboy::Goal")
      .update_all(taskable_type: "Dorsale::Flyboy::Folder")

    Dorsale::Comment
      .where(commentable_type: "CustomerVault::Corporation")
      .update_all(commentable_type: "Dorsale::CustomerVault::Corporation")
    Dorsale::Comment
      .where(commentable_type: "CustomerVault::Individual")
      .update_all(commentable_type: "Dorsale::CustomerVault::Individual")

    Dorsale::Address
      .where(addressable_type: "CustomerVault::Corporation")
      .update_all(addressable_type: "Dorsale::CustomerVault::Corporation")
    Dorsale::Address
      .where(addressable_type: "CustomerVault::Individual")
      .update_all(addressable_type: "Dorsale::CustomerVault::Individual")

    ActsAsTaggableOn::Tagging
      .where(taggable_type: "CustomerVault::Corporation")
      .update_all(taggable_type: "Dorsale::CustomerVault::Corporation")
    ActsAsTaggableOn::Tagging
      .where(taggable_type: "CustomerVault::Individual")
      .update_all(taggable_type: "Dorsale::CustomerVault::Individual")

    Dorsale::CustomerVault::Link
      .where(alice_type: "CustomerVault::Corporation")
      .update_all(alice_type: "Dorsale::CustomerVault::Corporation")
    Dorsale::CustomerVault::Link
      .where(alice_type: "CustomerVault::Individual")
      .update_all(alice_type: "Dorsale::CustomerVault::Individual")
    Dorsale::CustomerVault::Link
      .where(bob_type: "CustomerVault::Corporation")
      .update_all(bob_type: "Dorsale::CustomerVault::Corporation")
    Dorsale::CustomerVault::Link
      .where(bob_type: "CustomerVault::Individual")
      .update_all(bob_type: "Dorsale::CustomerVault::Individual")

  end
end
