class Dorsale::SmallData::FilterStrategyByTimePeriod < ::Dorsale::SmallData::FilterStrategyByKeyValue
  def apply(query, value)
    if value == "today"
      a = Time.zone.now.beginning_of_day
      b = Time.zone.now.end_of_day
    elsif value == "yesterday"
      a = (Time.zone.now - 1.day).beginning_of_day
      b = (Time.zone.now - 1.day).end_of_day
    elsif value == "this_week"
      a = Time.zone.now.beginning_of_week
      b = Time.zone.now.end_of_week
    elsif value == "this_month"
      a = Time.zone.now.beginning_of_month
      b = Time.zone.now.end_of_month
    elsif value == "this_year"
      a = Time.zone.now.beginning_of_year
      b = Time.zone.now.end_of_year
    elsif value == "last_week"
      a = (Time.zone.now - 1.week).beginning_of_week
      b = (Time.zone.now - 1.week).end_of_week
    elsif value == "last_month"
      a = (Time.zone.now - 1.month).beginning_of_month
      b = (Time.zone.now - 1.month).end_of_month
    elsif value == "last_year"
      a = (Time.zone.now - 1.year).beginning_of_year
      b = (Time.zone.now - 1.year).end_of_year
    else
      return query
    end

    criteria = "#{query.model.table_name}.#{key}"

    query
      .where("#{criteria} >= ?", a.to_date)
      .where("#{criteria} <= ?", b.to_date)
  end
end
