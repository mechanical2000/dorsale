require_dependency dorsale_file

Dorsale::ApplicationPolicy.class_eval do
  def self.define_dummy_policies!
    self::POLICY_METHODS.each do |method|
      define_method(method) { true }
    end
  end
end
