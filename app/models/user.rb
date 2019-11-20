class User < ApplicationRecord
    has_secure_password 
    has_many :messages 
    has_many :user_chatrooms
    has_many :chatrooms, through: :user_chatrooms
end