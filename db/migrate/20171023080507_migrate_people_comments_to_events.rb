class MigratePeopleCommentsToEvents < ActiveRecord::Migration[5.0]
  class Event < ::Dorsale::ApplicationRecord
    self.table_name = :dorsale_customer_vault_events

    belongs_to :comment, class_name: "Dorsale::Comment"
  end

  def change
    add_column :dorsale_customer_vault_events, :title, :string
    add_column :dorsale_customer_vault_events, :date, :date

    Event.where(action: "comment").each do |event|
      event.title = event.comment.title
      event.text  = event.comment.text
      event.date  = event.comment.date
      event.save!
      event.comment.destroy!
    end

    remove_column :dorsale_customer_vault_events, :comment_id
  end
end
