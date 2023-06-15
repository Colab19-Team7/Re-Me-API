class UserSerializer < ActiveModel::Serializer
  attributes :id, :fullname, :email, :avatar_url
end
