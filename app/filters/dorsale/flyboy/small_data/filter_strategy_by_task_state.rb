class Dorsale::Flyboy::SmallData::FilterStrategyByTaskState < ::Agilibox::SmallData::FilterStrategy
  STATES = Dorsale::Flyboy::Task::STATES + %w(on_warning_or_alert)

  def apply(query, value)
    if value.in?(STATES)
      query.public_send(value)
    else
      query
    end
  end
end
