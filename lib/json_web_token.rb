class JsonWebToken
  class << self
    # Test = "abc"
    KEY_BASE = Rails.application.secrets.secret_key_base
    def encode(payload)
      JWT.encode(payload, KEY_BASE, 'HS256')
    end

    def decode(token)
      payload = JWT.decode(token, KEY_BASE, true, {:algorithm => 'HS256'})[0]
      HashWithIndifferentAccess.new(payload)
    end
  end
end