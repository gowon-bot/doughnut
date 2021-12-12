require 'httparty'

class Discord
  include HTTParty

  base_uri 'https://discord.com/api/v8'

  def initialize
    @options = {}
  end

  def request_token(code)
    self.class.post('/oauth2/token', { headers: token_headers, body: token_body(code, 'authorization_code') })
  end

  def refresh_token(code)
    self.class.post('/outh2/token', { headers: token_headers, body: token_body(code, 'refresh_token') })
  end

  def me(token)
    self.class.get('/users/@me', options(token))
  end

  private

  def token_headers
    { 'Content-Type' => 'application/x-www-form-urlencoded' }
  end

  def token_body(code, grant_type)
    {
      client_id: ENV['DISCORD_CLIENT_ID'],
      client_secret: ENV['DISCORD_CLIENT_SECRET'],
      redirect_uri: ENV['DISCORD_REDIRECT_URI'],
      grant_type: grant_type,
      code: code
    }
  end

  def options(token)
    @options.merge({ headers: { 'Authorization' => "Bearer #{token}" } })
  end
end
