class Dorsale::CustomerVault::SmallData::FilterForPeople < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "person_type" => ::Dorsale::SmallData::FilterStrategyByKeyValue.new(:type),
    "person_tags" => ::Dorsale::SmallData::FilterStrategyByTags.new,
  }
end
