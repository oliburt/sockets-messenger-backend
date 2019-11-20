class ChatroomSerializer < ActiveModel::Serializer
  attributes :id, :description, :name, :creator_id, :public
  has_many :messages

end
