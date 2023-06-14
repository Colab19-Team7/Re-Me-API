class Api::V1::NotificationControlller < ApplicationController

    def index
        notifications = current_user.notifications.includes(:item).order(created_at: :desc)

        render json: notification, status: :ok
    end
end