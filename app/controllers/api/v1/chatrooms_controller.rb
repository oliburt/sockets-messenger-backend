class Api::V1::ChatroomsController < ApplicationController
    
    def index
        # only serve public chatrooms
        chatrooms = Chatroom.all.filter{|room| room.public }
        render json: chatrooms, each_serializer: SummarizedChatroomsSerializer
    end

    def uindex
      if @current_user
        chatrooms = Chatroom.all
        # Todo filter for current_user
        render json: chatrooms
      end
    end

    def create
      chatroom = Chatroom.new(chatroom_params)
      if chatroom.save
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
          ChatroomSerializer.new(chatroom)
        ).serializable_hash
        ActionCable.server.broadcast 'chatrooms_channel', serialized_data
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
      params.require(:chatroom).permit(:name, :description)
    end
end
