class NotificationSerializer < ActiveModel::Serializer
    attributes :id, :viewed
    has_one :item
end