module Dorsale::Users::PasswordGeneration
  def self.included(user_model)
    user_model.class_eval do
      before_validation :generate_password, on: :create
      after_create :send_welcome_email

      def generate_password
        self.password ||= SecureRandom.hex(6).to_s
      end

      def send_welcome_email
        Dorsale::UserMailer.new_account(self, password).deliver_later
      end

    end
  end
end
