class ItemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :item_image, :item_link
end
