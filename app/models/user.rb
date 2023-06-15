# frozen_string_literal: true

class User < ApplicationRecord
    has_secure_password

    has_many :items
    has_many :notifications
    has_and_belongs_to_many :categories, join_table: 'categories_users'

    validates :email, presence: true, uniqueness: true
    validates :fullname, presence: true
    # validates :password, presence: true

    def reach_limit?
        Item.get_no_visited_items(self).count >= 6
    end
end
