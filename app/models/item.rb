class Item < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: 'user_id'
    belongs_to :category, class_name: 'Category', foreign_key: 'category_id'

    enum :status, { no_viewed: 0, viewed: 1 }

    validates :item_link, presence: true, uniqueness: { scope: :user_id, message: "has already been saved" } 
end
