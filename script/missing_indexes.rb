connection = ActiveRecord::Base.connection

connection.tables.each do |table|
  columns = connection.columns(table).map(&:name)
    .select { |c| c.end_with?("_id") || c.end_with?("_type") }

  indexes = connection.indexes(table).flat_map(&:columns).uniq

  (columns - indexes).each do |column|
    puts "add_index :#{table}, :#{column}"
  end
end
