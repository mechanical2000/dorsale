class Dorsale::CustomerVault::SmallData::FilterForPeople < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "person_type"     => ::Agilibox::SmallData::FilterStrategyByKeyValue.new(:type),
    "person_tags"     => ::Agilibox::SmallData::FilterStrategyByTags.new,
    "person_origin"   => ::Agilibox::SmallData::FilterStrategyByKeyValue.new("origin_id"),
    "person_activity" => ::Dorsale::CustomerVault::SmallData::FilterStrategyByActivityType.new,
  }
end
