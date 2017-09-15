class Dorsale::CustomerVault::SmallData::FilterForEvents < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "event_action" => ::Agilibox::SmallData::FilterStrategyByKeyValues.new(:action),
  }
end
