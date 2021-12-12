require 'securerandom'

require_relative './DoughnutRedis'
require_relative './Token'

class TokenGenerator
  def build_token(code, discord_id)
    Token.new(generate_token, code, discord_id)
  end

  private

  def generate_token
    SecureRandom.base64
  end
end
