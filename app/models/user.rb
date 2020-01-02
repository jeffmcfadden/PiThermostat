require 'securerandom'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable
         
  before_validation :ensure_api_token
  
  validates :email, presence: true
  
  private
  
    def ensure_api_token
      return if self.api_token.present?
      self.api_token = SecureRandom.hex
    end
         
end
