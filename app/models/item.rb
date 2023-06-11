class Item < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: 'user_id'
    belongs_to :category, class_name: 'Category', foreign_key: 'category_id'
    has_one :notification

    enum :status, { no_viewed: 0, viewed: 1 }

    scope :get_visited_items, ->(user) { user.items.viewed.order(updated_at: :desc) }
    scope :get_no_visited_items, ->(user) { user.items.no_viewed.order(created_at: :desc) }

    validates :item_link, presence: true, uniqueness: { scope: :user_id, message: "has already been saved" } 
end
