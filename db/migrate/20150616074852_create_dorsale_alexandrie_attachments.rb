class CreateDorsaleAlexandrieAttachments < ActiveRecord::Migration
  def change
    create_table :dorsale_alexandrie_attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.string :file
    end
  end
end
