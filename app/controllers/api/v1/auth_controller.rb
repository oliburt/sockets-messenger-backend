class Api::V1::AuthController < ApplicationController
    
    def create
        user = User.find_by(username: user_login_params[:username])
        
        if user && user.authenticate(user_login_params[:password])
            jwt_token = issue_token(user_id: user.id)
            cookies.signed[:jwt] = {value: jwt_token, httponly: true, expires: 1.hour.from_now}
            render json: { user: UserSerializer.new(user) }, status: :accepted
        else
            render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
    end

    def validate
        if @current_user
            jwt_token = issue_token(user_id: @current_user.id)
            cookies.signed[:jwt] = {value: jwt_token, httponly: true, expires: 1.hour.from_now}
            render json: { user: UserSerializer.new(@current_user)}
        else
            render json: { errors: ["user not found"] }, status: :not_found
        end
    end

    def destroy
        cookies.delete(:jwt)
        @current_user.active_user = false
        @current_user.save
        
        ActionCable.server.broadcast("presence_channel", {type: "DC_USER", user_id: @current_user.id})
        
    end

    private

    def user_login_params
        params.require(:user).permit(:username, :password)
    end

end
