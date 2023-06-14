class NotificationSerializer < ActiveModel::Serializer
    attributes :id, :status, :item_id
    has_one :item
end