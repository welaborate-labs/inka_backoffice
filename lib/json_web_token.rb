require "jwt"

class JsonWebToken
  HMAC_SECRET = Rails.application.credentials.hmac_secret || ENV["HMAC_SECRET"]

  class << self
    def encode(customer_id)
      exp = (Time.now + 24.hours).to_i
      exp_payload = { customer_id: customer_id, exp: exp }

      JWT.encode exp_payload, HMAC_SECRET, "HS256"
    end

    def decode(token)
      decoded = JWT.decode token, HMAC_SECRET, true, { algorithm: "HS256" }
    rescue JWT::ExpiredSignature => expire
      return false
    rescue JWT::DecodeError => hmac_not_found
      return false
    end
  end
end
