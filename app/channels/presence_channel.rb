class PresenceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "presence_channel"
    current_user.active_user = true
    current_user.save

    ActionCable.server.broadcast("presence_channel", {type: "CO_USER", user_id: current_user.id})
  end

  def unsubscribed
    current_user.active_user = false
    current_user.save
    
    ActionCable.server.broadcast("presence_channel", {type: "DC_USER", user_id: current_user.id})
  end
end