# TODO :
# - Generate different UUIDs for same id in different tables
# - Generate different UUIDs for same table/id in different apps
# -> MD5(app_name/table/id)

require "pry"
require "awesome_print"
require "sequel"
require "digest"

DB = Sequel.connect("postgresql://root:@localhost/dorsale_development")

puts "enable_extension 'uuid-ossp'\n\n"

DB.tables.each do |table|
  DB[table].columns.each do |column|
    next unless column.to_s == "id" || column.to_s.end_with?("_id")
    next if column.to_s.include?("tracking_id")

    puts <<~END
      change_column :#{table}, :#{column}, :string
      change_column_default :#{table}, :#{column}, nil
      model = Class.new(ActiveRecord::Base)
      model.table_name = :#{table}
      model.reset_column_information
      model.distinct.pluck(:#{column}).each do |id|
        next if id.blank?
        uuid = Digest::MD5.hexdigest(id.to_s)
        model.where(#{column}: id).update_all(#{column}: uuid)
      end
      change_column :#{table}, :#{column}, "uuid USING CAST(#{column} AS uuid)"
      add_index :#{table}, :#{column} unless index_exists? :#{table}, :#{column}


    END
  end
end
