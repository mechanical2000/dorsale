class Dorsale::Flyboy::SmallData::FilterForTasks < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "fb_state"  => ::Dorsale::Flyboy::SmallData::FilterStrategyByTaskState.new,
    "fb_owner"  => ::Agilibox::SmallData::FilterStrategyByKeyValue.new(:owner_id),
  }
end
