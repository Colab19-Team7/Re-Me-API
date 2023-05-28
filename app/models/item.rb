class Item < ApplicationRecord
    belongs_to :user, class_name: 'User', foreign_key: 'user_id'

    enum :status, { no_viewed: 0, viewed: 1 }

    validates :item_link, presence: true, uniqueness: { scope: :title, message: "has already been saved" } 
end
