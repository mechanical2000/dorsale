module Dorsale::ModelToS
  def to_s
    %w(name title label).map do |m|
      return send(m) if respond_to?(m)
    end

    super
  end
end
