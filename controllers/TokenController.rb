require_relative './BaseController'
require_relative '../lib/http/Discord'
require_relative '../lib/TokenGenerator'
require_relative '../lib/DoughnutRedis'

class TokenController < BaseController
  def initialize
    @discord = Discord.new
    @token_generator = TokenGenerator.new
    @redis = DoughnutRedis.new
  end

  def request(request)
    params = json_params request

    response = @discord.request_token params['code']

    response_body = parse_json response

    access_token = response_body['access_token']

    me_response = @discord.me(access_token)

    me_response_body = parse_json me_response

    halt 401, { message: 'Invalid discord code!' } if me_response_body['id'].nil?

    token = @token_generator.build_token params['code'], me_response_body['id']

    token.save_to_redis

    token.as_public_hash.merge({ discord_user: me_response_body }).to_json
  end

  def destroy(request)
    params = json_params request

    token = params['token']

    halt 400, { message: 'Please supply a token!' } if token.nil?

    @redis.destroy_token token

    204
  end
end
