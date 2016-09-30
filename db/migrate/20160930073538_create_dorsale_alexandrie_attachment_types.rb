class CreateDorsaleAlexandrieAttachmentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :dorsale_alexandrie_attachment_types do |t|
      t.string :name
      t.timestamps null: false
    end

    add_column :dorsale_alexandrie_attachments, :attachment_type_id, :integer
    add_index :dorsale_alexandrie_attachments, :attachment_type_id
  end
end
