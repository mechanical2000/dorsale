class Dorsale::SmallData::Filter
  STRATEGIES = {}

  attr_reader :jar

  def initialize(jar)
    @jar = jar
  end

  def strategies
    self.class::STRATEGIES
  end

  def apply(query)
    strategies.each do |key, strategy|
      value = get(key)

      next if value.blank?

      query = strategy.apply(query, value)
    end

    return query
  end

  def method_missing(method, *args)
    if method.to_s.end_with?("=")
      key    = method.to_s[0..-2]
      value  = args.first
      action = :write
    else
      key    = method.to_s
      action = :read
    end

    if strategies.key?(key) && action == :read
      get(key)
    elsif strategies.key?(key) && action == :write
      set(key, value)
    else
      super
    end
  end

  def read
    JSON.parse jar["filters"].to_s
  rescue JSON::ParserError
    {}
  end

  def write(filters)
    jar["filters"] = filters.to_json
  end

  def merge(new_filters)
    write read.merge(new_filters)
  end

  private

  def get(key)
    read[key.to_s]
  end

  def set(key, value)
    merge(key.to_s => value)
  end
end
