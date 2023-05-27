class Api::V1::UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
    before_action :set_user, only: [:show, :update, :destroy]

    # GET /users
    def index
        @users = User.all 
        render json: @users, status: :ok
    end

    # GET /users/id
    def show
        render json: @user, status: :ok
    end

    # POST /users
    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PUT /users/{id}
    def update
        unless @user.update(user_params)
            render json: { errors: @user.errors.full_messages },
                    status: :unprocessable_entity
        end
    end

    # DELETE /users/{id}
    def destroy
        @user.destroy
    end

    private

    def set_user
        @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
        params.permit(:fullname, :email, :password)
    end
end