class TestController < ApplicationController
    skip_before_action :authenticate_request

    def index
        # video_params = LinkSpreader.call("https://www.youtube.com/watch?v=owObmOhY2Ko")
        # render json: video_params, status: :ok
        # WeeklyReminderMailer.send.deliver_now
        render file: Rails.root.join('public', 'test.html')
    end

    def test
        current_user = User.find(params[:user_id].to_i)
        if params[:category] === "mail"
            send_email(current_user)
        else
            send_notification(current_user)
        end
    end

    private

    def send_email(user)
        visited = Item.get_visited_items(user).where("created_at >= ?", Date.today.at_beginning_of_week).to_json
        no_visited = Item.get_no_visited_items(user).where("created_at >= ?", Date.today.at_beginning_of_week).to_json
        WeeklyReminderMailer.with(user: user, visited: visited, no_visited: no_visited).remind.deliver_later
    end

    def send_notification(user)
        ActionCable.server.broadcast "notification_#{params[:user_id]}_channel", current_user.to_json
    end
end