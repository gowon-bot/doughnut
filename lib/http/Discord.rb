require 'httparty'

class Discord
  include HTTParty

  base_uri 'https://discord.com/api/v10/'

  def initialize
    @options = {}
  end

  def request_token(code)
    self.class.post('/oauth2/token', { headers: token_headers, body: request_token_body(code) })
  end

  def refresh_token(refresh_token)
    self.class.post('/oauth2/token', { headers: token_headers, body: refresh_token_body(refresh_token) })
  end

  def me(token)
    self.class.get('/users/@me', options(token))
  end

  private

  def token_headers
    { 'Content-Type' => 'application/x-www-form-urlencoded' }
  end

  def base_token_body(grant_type)
    {
      client_id: ENV['DISCORD_CLIENT_ID'],
      client_secret: ENV['DISCORD_CLIENT_SECRET'],
      grant_type: grant_type
    }
  end

  def request_token_body(code)
    base_token_body('authorization_code').merge({ redirect_uri: ENV['DISCORD_REDIRECT_URI'], code: code })
  end

  def refresh_token_body(refresh_token)
    base_token_body('refresh_token').merge({ refresh_token: refresh_token })
  end

  def options(token)
    @options.merge({ headers: { 'Authorization' => "Bearer #{token}" } })
  end
end
