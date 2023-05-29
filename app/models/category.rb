class Category < ApplicationRecord
    has_many :items
    has_and_belongs_to_many :users, join_table: 'categories_users'

    validates :name, presence: true, uniqueness: true
end
