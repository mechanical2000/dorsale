class User < ::Dorsale::ApplicationRecord
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    # :confirmable,
    # :lockable,
    # :timeoutable,
    # :omniauthable,
  )

  include Dorsale::Users::Active
  include Dorsale::Users::PasswordGeneration
  include Dorsale::Users::Avatar

  def name
    email
  end
end
