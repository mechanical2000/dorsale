class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Dorsale::Users::Active
  include Dorsale::Users::PasswordGeneration
  include Dorsale::Users::Avatar

  def name
    email
  end
end
