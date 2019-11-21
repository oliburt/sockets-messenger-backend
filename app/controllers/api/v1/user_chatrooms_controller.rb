class Api::V1::UserChatroomsController < ApplicationController

    def create
        if @current_user
            chatroom = Chatroom.find(chatroom_params[:id])
            UserChatroom.create(user: @current_user, chatroom: chatroom)
            render json: chatroom
        else
            render json: { error: ['User must be logged in to Add Chatroom'] }, status: :not_accepted
        end
    end

    def destroy
        
    end

    private

    def chatroom_params
        params.require(:chatroom).permit(:id)
    end
end
