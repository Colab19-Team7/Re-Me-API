class ApplicationController < ActionController::API

    include JsonWebToken

    # before_action :authenticate_request
    
    def current_user
        @current_user
    end

    private
    
    def authenticate_request
        header = request.headers["Authorization"]
        header = header.split(" ").last if header

        begin
            decoded = jwt_decode(header)
            @current_user = User.find(decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def set_item
        @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { errors: "Item not fount" }, status: :not_found
    end

    def user_ability
        authorize! :manage, @item
    rescue CanCan::AccessDenied
        render json: { errors: 'You are not authorized to perform this action' },
               status: :unauthorized
    end
end
