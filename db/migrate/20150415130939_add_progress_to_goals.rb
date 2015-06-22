class AddProgressToGoals < ActiveRecord::Migration
  def change
    add_column :dorsale_flyboy_goals, :progress, :integer
    Dorsale::Flyboy::Goal.all.map(&:update_progress!)
  end
end
