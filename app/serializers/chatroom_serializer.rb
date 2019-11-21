class ChatroomSerializer < ActiveModel::Serializer
  attributes :id, :description, :name, :creator_id, :public, :users
  has_many :messages
  
  def users
    self.object.users.map{|u| u.id}
  end
end
