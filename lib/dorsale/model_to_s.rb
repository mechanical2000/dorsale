module Dorsale
  module ModelToS
    def to_s
      %w(name title label).map do |m|
        return send(m) if respond_to?(m)
      end

      super
    end
  end
end

ActiveRecord::Base.send(:include, ::Dorsale::ModelToS)
