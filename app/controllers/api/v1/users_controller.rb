class Api::V1::UsersController < ApplicationController
    def index
        render json: User.all
    end
    
    def create
        user = User.create(user_params)
        if user.valid?
            jwt_token = issue_token(user_id: user.id)
            cookies.signed[:jwt] = {value: jwt_token, httponly: true, expires: 1.hour.from_now}
            render json: { user: UserSerializer.new(user) }, status: :accepted
        else
            render json: { errors: user.errors.full_messages }, status: :not_acceptable
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation)
    end

end
