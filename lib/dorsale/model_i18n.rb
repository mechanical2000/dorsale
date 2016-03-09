module Dorsale
  module ModelI18n
    def t(*args)
      self.class.t(*args)
    end

    def ts
      self.class.ts
    end

    def self.included(model)
      model.instance_eval do
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

      end # instance_eval
    end # def included
  end # ModelI18n
end # Dorsale

ActiveRecord::Base.send(:include, ::Dorsale::ModelI18n)
