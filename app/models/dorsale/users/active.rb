module Dorsale::Users::Active
  def self.included(user_model)
    user_model.class_eval do
      validates :is_active, inclusion: {in: [true, false]}

      scope :actives, -> { where(is_active: true) }

      def initialize(*)
        super
        self.is_active = true if is_active.nil?
      end

      def active_for_authentication?
        super && self.is_active?
      end

      def inactive_message
        I18n.t("messages.users.inactive")
      end
    end
  end
end
