class Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer < ::Agilibox::SmallData::FilterStrategy
  def apply(query, value)
    type, id = value.split("-", 2)
    query.where(customer_type: type, customer_id: id)
  end
end
