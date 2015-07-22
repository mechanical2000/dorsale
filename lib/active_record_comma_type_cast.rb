module ActiveRecordCommaTypeCast
  def cast_value(value)
    if value.is_a?(String)
      super value.gsub(",", ".").gsub(" ", "")
    else
      super value
    end
  end
end

ActiveRecord::Type::Decimal.send(:prepend, ::ActiveRecordCommaTypeCast)
ActiveRecord::Type::Float.send(:prepend, ::ActiveRecordCommaTypeCast)
