class Dorsale::ExpenseGun::SmallData::FilterForExpenses < ::Agilibox::SmallData::Filter
  STRATEGIES = {
    "expense_state"   => ::Agilibox::SmallData::FilterStrategyByKeyValue.new("state"),
    "expense_user_id" => ::Agilibox::SmallData::FilterStrategyByKeyValue.new("user_id"),
  }
end
