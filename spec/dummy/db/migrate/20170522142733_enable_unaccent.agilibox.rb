# This migration comes from agilibox (originally 20170502143330)
class EnableUnaccent < ActiveRecord::Migration[5.0]
  def change
    enable_extension "unaccent"
  end
end
