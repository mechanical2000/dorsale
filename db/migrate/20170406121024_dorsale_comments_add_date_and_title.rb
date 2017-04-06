class DorsaleCommentsAddDateAndTitle < ActiveRecord::Migration[5.0]
  def change
    add_column :dorsale_comments, :date,  :date
    add_column :dorsale_comments, :title, :string
    Dorsale::Comment.update_all("date = created_at")
  end
end
