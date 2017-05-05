class Dorsale::CustomerVault::SmallData::FilterStrategyByActivityType < ::Agilibox::SmallData::FilterStrategy
  def apply(query, value)
    corporations_id = query.where(activity_type_id: value).pluck(:id)
    individuals_id  = query.where(corporation_id: corporations_id).pluck(:id)
    query.where(id: (corporations_id + individuals_id))
  end
end
