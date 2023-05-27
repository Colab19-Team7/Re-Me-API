# frozen_string_literal: true

class SessionsController < ApplicationController
    skip_before_action :authenticate_request

    # POST /sessions/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: { user: @user, token: token }, status: :ok
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end
end