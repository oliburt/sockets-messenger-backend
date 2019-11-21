class Api::V1::ChatroomsController < ApplicationController
    
    def index
        # only serve public chatrooms
        chatrooms = Chatroom.all.filter{|room| room.public }
        render json: chatrooms, each_serializer: SummarizedChatroomsSerializer
    end

    def uindex
      if @current_user
        chatrooms = Chatroom.includes(:users).where('users.id = ?', @current_user.id).references(:users)
        # Todo filter for current_user
        render json: chatrooms
      else
        render json: []
      end
    end

    def show
      chatroom = Chatroom.find(params[:id])
      if chatroom
        render json: chatroom
      else
        render json: {error: ['This chatroom was not found']}, status: :not_found
      end
    end

    def create
      chatroom = Chatroom.new(chatroom_params)
      if chatroom.save
        ownership = UserChatroom.create(chatroom: chatroom, user: @current_user)

        serialized_data = ActiveModelSerializers::Adapter::Json.new(
          ChatroomSerializer.new(chatroom)
        ).serializable_hash
        public_serialized_data = ActiveModelSerializers::Adapter::Json.new(
          SummarizedChatroomsSerializer.new(chatroom)
        ).serializable_hash

        ActionCable.server.broadcast 'chatrooms_channel', chatroom: public_serialized_data, public: true
        
        ActionCable.server.broadcast "current_user_#{@current_user.id}", serialized_data
        head :ok
      end
    end

    def dmcreate
      chatroom = Chatroom.new(chatroom_params)
      if chatroom.save
        receiver = User.find(params[:receiver_id])

        ownership1 = UserChatroom.create(chatroom: chatroom, user: @current_user)
        ownership2 = UserChatroom.create(chatroom: chatroom, user: receiver)

        serialized_data = ActiveModelSerializers::Adapter::Json.new(
          ChatroomSerializer.new(chatroom)
        ).serializable_hash

        ActionCable.server.broadcast "current_user_#{@current_user.id}", chatroom: serialized_data, dm: true
        ActionCable.server.broadcast "current_user_#{receiver.id}", serialized_data
        head :ok
      end
    end

    def destroy
      chatroom = Chatroom.find(params[:id])
      chatroom.messages.each{|msg| msg.destroy}
      if chatroom.destroy
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
            ChatroomSerializer.new(chatroom)
        ).serializable_hash
        ActionCable.server.broadcast 'chatrooms_channel', 
        chatroom: serialized_data,
        deleted: true
        head :no_content
      end
    end
      
    private
    
    def chatroom_params
      params.require(:chatroom).permit(:name, :description, :creator_id, :public)
    end
end
