class Notification < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :item, class_name: 'Item', foreign_key: 'item_id'

  after_commit :send_reminder, on: :create

  def send_reminder
    r_item = ItemSerializer.new(item).to_json
    ActionCable.server.broadcast "notification_channel_#{user.id}", r_item
  end
end
