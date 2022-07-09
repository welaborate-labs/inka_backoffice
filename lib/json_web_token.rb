require "jwt"

class JsonWebToken
  HMAC_SECRET = ENV["HMAC_SECRET"]

  class << self
    def encode
      exp = (Time.now + 24.hours).to_i
      exp_payload = { exp: exp }

      JWT.encode exp_payload, HMAC_SECRET, "HS256"
    end

    def decode(token)
      JWT.decode token, HMAC_SECRET, true, { algorithm: "HS256" }
    rescue JWT::ExpiredSignature => expire
      return false
    rescue JWT::DecodeError => hmac_not_found
      return false
    end
  end
end
