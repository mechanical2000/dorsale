class Dorsale::Flyboy::SmallData::FilterForTasks < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "fb_status" => ::Dorsale::Flyboy::SmallData::FilterStrategyByDone.new,
    "fb_owner"  => ::Agilibox::SmallData::FilterStrategyByKeyValue.new(:owner_id)
  }
end
