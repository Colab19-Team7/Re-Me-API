class Api::V1::NotificationsController < ApplicationController
    before_action :set_notification, only: %i[update]

    def index
        notifications = current_user.notifications.includes(:item).order(created_at: :desc)

        render json: notifications, status: :ok
    end

    def update
        @notification.update(viewed: true)
    end

    private

    def set_notification
        @notification = Notification.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Notification not found' }, status: :not_found
    end
end