
    class ApplicationController < ActionController::API
        include ::ActionController::Cookies
        
        before_action :set_current_user
    
        def issue_token(payload)
            # byebug
            JWT.encode(payload, ENV['RAILS_SECRET'])
        end
    
        def decode_token(token)
            JWT.decode(token, ENV['RAILS_SECRET'])[0]
        end
    
        def get_token
            cookies.signed[:jwt] 
        end
    
        def set_current_user
            token = get_token
            if token
                decoded_token = decode_token(token)
                user = User.find_by_id(decoded_token["user_id"])
                if user
                    @current_user = user
                else
                    cookies.delete(:jwt)
                    @current_user = nil
                end
            else
                @current_user = nil
            end
        end
    
        def logged_in
            !!@current_user
        end
    end