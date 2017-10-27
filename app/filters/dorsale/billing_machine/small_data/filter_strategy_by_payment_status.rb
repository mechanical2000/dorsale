class Dorsale::BillingMachine::SmallData::FilterStrategyByPaymentStatus < ::Agilibox::SmallData::FilterStrategy
  def apply(query, value)
    table_name = query.model.table_name

    if value == "paid"
      query.where(paid: true)
    elsif value == "unpaid"
      query.where(paid: false)
    elsif value == "pending"
      query
        .where(paid: false)
        .where("#{table_name}.due_date >= ?", Date.current)
    elsif value == "late"
      query
        .where(paid: false)
        .where("#{table_name}.due_date < ? OR #{table_name}.due_date IS NULL)", Date.current)
    else
      query
    end
  end
end
