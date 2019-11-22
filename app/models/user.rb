class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: true
    has_many :messages 
    has_many :user_chatrooms
    has_many :chatrooms, through: :user_chatrooms
end