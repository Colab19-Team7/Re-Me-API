class NotificationChannel < ApplicationCable::Channel

  def subscribed
    # stream_from "some_channel"
    # find_verified_user(params[:token])
    stream_from "notification_channel_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts '********** SERVER CLOSE *******************/n'
  end

  # private

  # include JsonWebToken
  # def find_verified_user(token)
  #   begin
  #     token = request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL]
  #     decoded = jwt_decode(token)
  #     if (current_user = User.find(decoded[:user_id]))
  #       current_user
  #     else
  #       reject_unauthorized_connection
  #     end
  #   rescue
  #     reject_unauthorized_connection
  #   end
  # end
end
