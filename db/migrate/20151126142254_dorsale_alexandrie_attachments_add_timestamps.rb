class DorsaleAlexandrieAttachmentsAddTimestamps < ActiveRecord::Migration
  def change
      change_table :dorsale_alexandrie_attachments do |t|
          t.timestamps
      end
  end
end
