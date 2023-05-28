# frozen_string_literal: true

class User < ApplicationRecord
    has_secure_password

    has_many :items

    validates :email, presence: true, uniqueness: true
    validates :fullname, presence: true
    validates :password, presence: true
end
