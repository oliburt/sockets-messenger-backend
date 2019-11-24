module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = cookies.signed[:jwt]
      if token
        verified_user = User.find_by_id(JWT.decode(token, ENV['RAILS_SECRET'])[0]["user_id"])
        if verified_user
          verified_user
        else
          cookies.delete(:jwt)
          reject_unauthorized_connection
        end
      else
        reject_unauthorized_connection
      end
    end
  end
end
