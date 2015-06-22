class StatesToString < ActiveRecord::Migration
  def change
    change_column :dorsale_flyboy_goals, :status, :string
  end
end
