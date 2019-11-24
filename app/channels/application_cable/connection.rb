module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      
      verified_user = User.find(JWT.decode(cookies.signed[:jwt], ENV['RAILS_SECRET'])[0]["user_id"])
      if verified_user
        verified_user
      else
        cookies.delete(:jwt)
        reject_unauthorized_connection
      end
    end
  end
end
