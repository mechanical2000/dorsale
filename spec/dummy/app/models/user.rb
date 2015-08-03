class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def name
    email
  end

  def tasks
    Dorsale::Flyboy::Task.all
  end

  def colleagues origin
    return [self]
  end
end
