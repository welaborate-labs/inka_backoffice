require "jwt"

class JsonWebToken
  @hmac_secret = ENV["HMAC_SECRET"]
  class << self
    def encode
      exp = (Time.now + 24.hours).to_i
      exp_payload = { exp: exp }

      JWT.encode exp_payload, @hmac_secret, "HS256"
    end

    def decode(token)
      JWT.decode token, @hmac_secret, true, { algorithm: "HS256" }
    rescue JWT::ExpiredSignature => expire
      return false
    rescue JWT::DecodeError => hmac_not_found
      return false
    end
  end
end
