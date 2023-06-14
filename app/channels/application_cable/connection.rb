module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
    include JsonWebToken

    def find_verified_user
      begin
        token = request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL]
        decoded = jwt_decode(token)
        if (current_user = User.find(decoded[:user_id]))
          current_user
        else
          reject_unauthorized_connection
        end
      rescue
        reject_unauthorized_connection
      end
    end
  end
end
