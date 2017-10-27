class Dorsale::BillingMachine::SmallData::FilterStrategyByState < ::Agilibox::SmallData::FilterStrategy
  def apply(query, value)
    if (m = value.to_s.match(/not_(.+)/))
      query.where.not(state: m[1])
    else
      query.where(state: value)
    end
  end
end
