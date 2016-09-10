class Dorsale::BillingMachine::SmallData::FilterStrategyByCustomer < ::Dorsale::SmallData::FilterStrategy
  def apply(query, value)
    type, id = value.split("-")
    type = "Dorsale::CustomerVault::Person" if type == "Dorsale::CustomerVault::Corporation"
    type = "Dorsale::CustomerVault::Person" if type == "Dorsale::CustomerVault::Individual"
    query.where(customer_type: type, customer_id: id)
  end
end
