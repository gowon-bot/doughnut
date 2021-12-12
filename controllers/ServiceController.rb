require 'yaml'

require_relative './BaseController'
require_relative '../lib/DoughnutRedis'
require_relative '../lib/RequestForwarder'

class ServiceController < BaseController
  def initialize
    @services = get_services
    @redis = DoughnutRedis.new
    @request_forwarder = RequestForwarder.new
  end

  def request(request, params)
    halt 400, { message: "That service doesn't exist" } unless is_valid_service? params[:service]

    token = get_token_from_header request.env[request_header 'authorization']

    halt 401, { message: 'Invalid token' } if token.nil?

    service = get_service params[:service]

    @request_forwarder.forward request, service['url'] + '/' + params['splat'][0], token
  end

  private

  def is_valid_service?(service_string)
    @services.key? service_string
  end

  def get_service(service_string)
    @services[service_string]
  end

  def get_token_from_header(header)
    return nil if header.nil?

    auth = header.split(/ /)

    return nil unless auth[0] == 'Bearer' && !auth[1].nil?

    token = @redis.get_token(auth[1])

    return nil if !token || token.expired?

    token
  end
end

def get_services
  YAML.load_file('services.yml')['services']
rescue StandardError
  puts 'Aborted! Please fill out the services.yml file!'
  exit
end
