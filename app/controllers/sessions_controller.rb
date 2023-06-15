# frozen_string_literal: true

class SessionsController < ApplicationController
    skip_before_action :authenticate_request

    # POST /sessions/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: { user: UserSerializer.new(@user), token: token }, status: :ok
        else
            render json: { error: 'unauthorized' }, status: :unauthorized
        end
    end

    def google_oauth
        client_id = Rails.application.credentials.google_client_id
        begin
            data = Google::Auth::IDTokkens.verify_oidc params[:token], aud: client_id
        rescue StandardError => e
            render json: { error: e.message }, status: :unauthorized
        end
    end
end