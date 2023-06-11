class TestController < ApplicationController

    def index
        # video_params = LinkSpreader.call("https://www.youtube.com/watch?v=owObmOhY2Ko")
        # render json: video_params, status: :ok
        render file: Rails.root.join('public', 'test.html')
    end

    def test
        user = params[:message].to_json
        ActionCable.server.broadcast "notification_#{params[:user_id]}_channel", user
    end
end