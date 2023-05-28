class Api::V1::ItemsController < ApplicationController
    before_action :set_item, only: %i[show update destroy]
    before_action :video_params, only: %i[create update]

    # GET /items
    def index
        items = @current_user.items
        render json: items, status: :ok
    end

    # GET /items/id
    def show
        render json: @item, status: :ok
    end

    # POST /items
    def create
        @item = @current_user.items.new(video_params)

        if @item.save
            render json: @item, status: :created
        else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PATCH PUT /items/id
    def update
        unless @item.update(video_params)
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # DELETE /items/id
    def destroy
        @item.destroy
    end

    private
    
    def set_item
        @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "Item not fount" }, status: :not_found
    end

    def video_params
        LinkSpreader.call(params[:link])
    end
end