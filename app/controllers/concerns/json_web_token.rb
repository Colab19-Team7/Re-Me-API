# frozen_string_literal: true

require "jwt"
module JsonWebToken
    extend ActiveSupport::Concern
    SECRETE_KEY = Rails.application.secret_key_base

    def jwt_encode(payload)
        JWT.encode(payload, SECRETE_KEY)
    end

    def jwt_decode(token)
        decoded = JWT.decode(token, SECRETE_KEY)[0]
        HashWithIndifferentAccess.new decoded
    end
end