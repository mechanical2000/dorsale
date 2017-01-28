module Dorsale::ModelI18n
  extend ActiveSupport::Concern

  def t(*args)
    self.class.t(*args)
  end

  def ts
    self.class.ts
  end

  class_methods do
    def t(*args)
      if args.any?
        human_attribute_name(*args)
      else
        model_name.human
      end
    end

    def ts
      model_name.human(count: 2)
    end
  end # class_methods
end # Dorsale::ModelI18n
