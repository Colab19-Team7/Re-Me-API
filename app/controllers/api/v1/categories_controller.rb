class Api::V1::CategoriesController < ApplicationController
    before_action :set_category, except: %i[index]

    def index
        categories = @current_user.categories.order(created_at: :desc)

        render json: categories, status: :ok
    end

    def show
        items = @category.items.includes(:user).where(items: {user_id: @current_user.id}).order(created_at: :desc)
        category_sel = @category.serializable_hash
        category_sel[:items] = items

        render json: category_sel, status: :ok
    end

    def destroy
        user_id = @current_user.id
        category_id = @category.id
        sql = "DELETE FROM categories_users WHERE user_id=#{user_id} AND category_id=#{category_id}"
        ActiveRecord::Base.connection.execute(sql)
    end

    private

    def set_category
        @category = Category.find_by(name: params[:name])
    end

    def category_items
        Item.where(user: @current_user, category: @category)
    end
end