module Dorsale
  module ModelI18n
    def t(*args)
      self.class.human_attribute_name(*args)
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
      end
    end
  end
end

ActiveRecord::Base.send(:include, ::Dorsale::ModelI18n)
