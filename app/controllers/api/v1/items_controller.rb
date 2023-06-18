class Api::V1::ItemsController < ApplicationController
    before_action :set_item, only: %i[show update destroy]
    before_action :user_ability, only: %i[show, update, destroy]
    before_action :user_limit, only: %i[create]

    # GET /items
    def index
        items = Item.get_no_visited_items(current_user)
        render json: items, status: :ok
    end

    # GET /items/id
    def show
        render json: @item, status: :ok
    end

    # POST /items
    def create
        @item = @current_user.items.new(video_params)
        category = get_category(params[:link])
        @item.category = category

        if @item.save
            category.items << @item unless category.items.include?(@item)
            # RemindJob.set(wait_until: Time.now.tomorrow).perform_later(current_user, @item.id)
            RemindJob.set(wait: 2.minutes).perform_later(current_user, @item.id)

            render json: @item, status: :created
        else
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # PATCH PUT /items/id
    def update
        unless @item.update(item_params)
            render json: { errors: @item.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # DELETE /items/id
    def destroy
        @item.destroy
    end

    private

    def video_params
        return LinkSpreader.call(params[:link]) if(params[:item_image].nil? || params[:item_image].strip.empty?)
        LinkSpreader.call(params[:link], params[:item_image])
    end

    def item_params
        params.permit(:title, :description, :item_image)
    end

    def user_limit
        render json: { errors: "Sorry you reach your limit" }, status: :unauthorized  if current_user.reach_limit?
    end

    include CreateCategory
end