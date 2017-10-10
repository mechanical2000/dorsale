class Dorsale::Flyboy::SmallData::FilterStrategyByTaskState < ::Agilibox::SmallData::FilterStrategy
  def apply(query, value)
    if value.in?(Dorsale::Flyboy::Task::STATES)
      query.send(value)
    else
      query
    end
  end
end
