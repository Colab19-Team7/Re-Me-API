class Api::V1::ArchiveController < ApplicationController
    before_action :set_item, only: [:update_status]
    before_action :user_ability, only: [:update_status]

    def update_status
        @item.viewed!
    end

    def archives
        items = Item.get_visited_items(current_user)
        
        render json: items, status: :ok
    end
end