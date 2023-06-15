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
            data = Google::Auth::IDTokens.verify_oidc params[:token], aud: client_id
            user_check = User.find_by_email(data['email'])
            if(user_check)
                user_check.update(avatar_url: data['picture']) if user_check.avatar_url.nil?
            else
                user_check = create_new_user(data)
            end

            token = jwt_encode(user_id: user_check.id)
            render json: { user: UserSerializer.new(user_check), token: token }, status: :ok
        rescue StandardError => e
            render json: { error: e.message }, status: :unauthorized
        end
    end

    private

    def create_new_user (data)
        password = SucureRandom.base64(15)
        new_user = User.create(
            fullname: data['name'],
            email: data['email'],
            avatar_url: data['picture']
            password: password
        )
    end
end