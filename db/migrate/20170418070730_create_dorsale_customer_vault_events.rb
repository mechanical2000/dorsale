class CreateDorsaleCustomerVaultEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :dorsale_customer_vault_events do |t|
      t.integer :author_id
      t.integer :person_id
      t.integer :comment_id
      t.string :action
      t.timestamps
    end

    Dorsale::CustomerVault::Person.all.each do |person|
      event            = Dorsale::CustomerVault::Event.new
      event.person     = person
      event.action     = "create"
      event.created_at = person.created_at
      event.updated_at = person.created_at
      event.save(validate: false)
    end

    Dorsale::Comment.where(commentable_type: Dorsale::CustomerVault::Person.to_s).all.each do |comment|
      event            = Dorsale::CustomerVault::Event.new
      event.author     = comment.author
      event.person     = comment.commentable
      event.comment    = comment
      event.action     = "comment"
      event.created_at = comment.created_at
      event.updated_at = comment.created_at
      event.save!
    end
  end
end
