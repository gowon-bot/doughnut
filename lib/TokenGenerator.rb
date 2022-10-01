require 'securerandom'

require_relative './DoughnutRedis'
require_relative './Token'

class TokenGenerator
  def build_token(discord_id, response)
    Token.new(
      generate_token,
      discord_id,
      response['refresh_token'],
      Time.now + response['expires_in']
    )
  end

  private

  def generate_token
    SecureRandom.base64
  end
end
