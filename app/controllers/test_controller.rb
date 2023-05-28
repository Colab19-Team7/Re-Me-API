class TestController < ApplicationController

    def index
        video_params = LinkSpreader.call("https://www.youtube.com/watch?v=owObmOhY2Ko")
        render json: video_params, status: :ok
    end
end