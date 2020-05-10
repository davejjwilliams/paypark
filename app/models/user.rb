class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = SecureRandom.hex
    end


  end

  after_create :signup_confirmation
  def signup_confirmation
    UserMailer.signup_confirmation(self).deliver
    
  end
  # Chat associations
  has_many :conversations, foreign_key: :sender_id
  has_many :messages
end
