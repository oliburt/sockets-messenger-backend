class ChatroomsChannel < ApplicationCable::Channel
    def subscribed
      # generic channel for public chatrooms
      stream_from "chatrooms_channel"

      # private channel for each user
      stream_from "current_user_#{current_user.id}"
    end
  
    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  end