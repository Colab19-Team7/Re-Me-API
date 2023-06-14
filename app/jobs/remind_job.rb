class RemindJob < ApplicationJob
  queue_as :default

  def perform(user, id)
    # Do something later
    item = Item.find(id)
    return if item.viewed?

    # Notification.first.send_reminder
    Notification.create(user: user, item: item)
  end
end
