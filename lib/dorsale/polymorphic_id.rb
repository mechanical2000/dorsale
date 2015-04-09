module Dorsale
  module PolymorphicId
    module ClassMethods
      def polymorphic_id_for(relation_name)
        module_src = File.read(__FILE__).split("__END__").last
        module_src = module_src.gsub("relation", relation_name.to_s)
        send :include, eval(module_src)
      end
    end

    def self.included(model)
      model.send(:extend, Dorsale::PolymorphicId::ClassMethods)
    end

    def guid
      return nil if new_record?

      "#{self.class}-#{self.id}"
    end
  end
end

# __END__

Module.new do
  def relation_guid
    return nil if relation_type.blank? || relation_id.blank?

    "#{relation_type}-#{relation_id}"
  end

  def relation_guid=(guid)
    return self.relation = nil if guid.blank?

    type, id      = guid.split("-")
    self.relation = type.constantize.find(id)
  end
end
