class TestController < ApplicationController

    def index
        # video_params = LinkSpreader.call("https://www.youtube.com/watch?v=owObmOhY2Ko")
        # render json: video_params, status: :ok
        render file: Rails.root.join('public', 'test.html')
    end

    def test
        current_user = User.find(2)
        item = current_user.items.first.id
        RemindJob.perform_later(user, item)
    end
end