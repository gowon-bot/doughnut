require 'sinatra'
require 'httparty'

class RequestForwarder
  def forward(request, uri, token, service)
    headers = get_headers request

    headers = set_custom_headers headers, token, service

    method = get_method(request)

    res = HTTParty.send(method, uri, headers: headers, body: request.body.read.to_s)

    res.body
  end

  private

  def get_method(request)
    return :get if request.get?
    return :post if request.post?
    return :delete if request.delete?
    return :options if request.options?
    return :head if request.head?
    return :patch if request.patch?
  end

  def get_headers(request)
    new_hash = {}

    request.env.each { |key, value| new_hash[key.sub('HTTP_', '').gsub('_', '-').upcase] = value if key.upcase == key }

    new_hash
  end

  def set_custom_headers(headers, token, service)
    headers['AUTHORIZATION'] = ENV[service['passwordEnv']] if service['passwordEnv']
    headers['HOST'] = get_host service unless headers['HOST'].nil?

    return headers if token.nil?

    headers['DOUGHNUT-DISCORD-ID'] = token.discord_id


    headers
  end

  def get_host(service)
    service['url'].split('/')[2].split(':')[0]
  end
end
