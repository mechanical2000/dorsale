class Dorsale::ExpenseGun::SmallData::FilterForExpenses < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "expense_state"       => ::Agilibox::SmallData::FilterStrategyByKeyValue.new("state"),
    "expense_user_id"     => ::Agilibox::SmallData::FilterStrategyByKeyValue.new("user_id"),
    "expense_time_period" => ::Agilibox::SmallData::FilterStrategyByDatePeriod.new(:date),
    "expense_date_begin"  => ::Agilibox::SmallData::FilterStrategyByDateBegin.new(:date),
    "expense_date_end"    => ::Agilibox::SmallData::FilterStrategyByDateEnd.new(:date),
  }
end
