class Item < ApplicationRecord
    enum :status, { no_visited: 0, visited: 1 }

    validates :link, presence: true
end
