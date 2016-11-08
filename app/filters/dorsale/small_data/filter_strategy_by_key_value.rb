class Dorsale::SmallData::FilterStrategyByKeyValue < ::Dorsale::SmallData::FilterStrategy
  attr_reader :key

  def initialize(key = nil)
    @key = key
  end

  def apply(query, value)
    value = true  if value == "true"
    value = false if value == "false"
    value = nil   if value == "nil"
    value = nil   if value == "null"

    query.where("#{key} = ?", value)
  end
end
