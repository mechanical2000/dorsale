module Dorsale::ActiveRecordCommaTypeCast
  def cast_value(value)
    if value.is_a?(String)
      super value.gsub(",", ".").gsub(/[^-0-9\.]/, "")
    else
      super value
    end
  end
end

ActiveRecord::Type::Decimal.send(:prepend, Dorsale::ActiveRecordCommaTypeCast)
ActiveRecord::Type::Float.send(:prepend, Dorsale::ActiveRecordCommaTypeCast)
