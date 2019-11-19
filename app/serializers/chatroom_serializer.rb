class ChatroomSerializer < ActiveModel::Serializer
  attributes :id, :description, :name, :creator_id
  has_many :messages

end
