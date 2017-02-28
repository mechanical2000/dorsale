class Dorsale::CustomerVault::SmallData::FilterForPeople < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "person_type" => ::Agilibox::SmallData::FilterStrategyByKeyValue.new(:type),
    "person_tags" => ::Agilibox::SmallData::FilterStrategyByTags.new,
  }
end
