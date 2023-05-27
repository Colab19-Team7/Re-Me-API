class HomeController < ApplicationController
    skip_before_action :authenticate_request

    def index
        render json: { message: "Home page" }, status: :ok
    end
end