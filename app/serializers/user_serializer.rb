class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :active_user
end
