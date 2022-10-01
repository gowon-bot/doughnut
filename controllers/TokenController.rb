require_relative './BaseController'
require_relative '../lib/http/Discord'
require_relative '../lib/TokenGenerator'
require_relative '../lib/DoughnutRedis'
require_relative '../lib/Token'

class TokenController < BaseController
  def initialize
    @discord = Discord.new
    @token_generator = TokenGenerator.new
    @redis = DoughnutRedis.new
  end

  def request(request)
    params = json_params request

    response = @discord.request_token params['code']

    handle_access_token_response(response)
  end

  def refresh(request)
    token = Token.from_auth_header(@redis, request.env[request_header('authorization')])

    halt 401, { message: 'Invalid token' } if token.nil? or token.refresh_token.nil?

    response = @discord.refresh_token(token.refresh_token)

    handle_access_token_response(response)
  end

  def destroy(request)
    params = json_params request

    token = params['token']

    halt 400, { message: 'Please supply a token!' } if token.nil?

    @redis.destroy_token token

    204
  end

  private

  def handle_access_token_response(response)
    response_body = parse_json response

    access_token = response_body['access_token']

    me_response = @discord.me(access_token)

    me_response_body = parse_json me_response

    halt 401, { message: 'Invalid discord code or refresh_token!' } if me_response_body['id'].nil?

    token = @token_generator.build_token me_response_body['id'], response_body

    token.save_to_redis

    token.as_hash_with_discord_user(me_response_body).to_json
  end
end
