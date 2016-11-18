module Dorsale::DefaultValuesConcern
  extend ActiveSupport::Concern

  def assign_default_values; end

  def assign_default(attribute, value)
    self.send("#{attribute}=", value) if self.send(attribute).nil?
  end

  included do
    after_initialize :assign_default_values
  end
end
