class DorsaleAlexandrieAttachmentsAddSender < ActiveRecord::Migration
  def change
    add_column :dorsale_alexandrie_attachments, :sender_id, :integer
    add_column :dorsale_alexandrie_attachments, :sender_type, :string
  end
end
