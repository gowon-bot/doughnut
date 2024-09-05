# Load variables from .env
require 'dotenv/load'

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/cors'

require 'sinatra/reloader' if development?

require_relative 'setup'
require_relative 'controllers/BaseController'
require_relative 'controllers/TokenController'
require_relative 'controllers/ServiceController'

setup

token_controller = TokenController.new
service_controller = ServiceController.new

set :allow_origin, '*'
set :allow_methods, 'GET,POST,OPTIONS,HEAD,PATCH'
set :allow_headers, 'Authorization,Content-Type'

set :public_folder, 'public'

set :port, ENV['PORT']
set :server, 'puma'

before do
  content_type 'application/json'
end

helpers do
  def halt_if_error
    yield
  rescue HTTPError => e
    halt e.code, e.message.to_json
  end
end

post '/token/request' do
  halt_if_error { token_controller.request request }
end

post '/token/destroy' do
  halt_if_error { token_controller.destroy request }
end

post '/token/refresh' do
  halt_if_error { token_controller.refresh request }
end

# Service

get '/services/:service/*' do
  halt_if_error { service_controller.request(request, params) }
end

post '/services/:service/*' do
  halt_if_error { service_controller.request(request, params) }
end

options '/services/:service/*' do
  halt_if_error { service_controller.request(request, params) }
end

patch '/services/:service/*' do
  halt_if_error { service_controller.request(request, params) }
end

head '/services/:service/*' do
  halt_if_error { service_controller.request(request, params) }
end

delete '/services/:service/*' do
  halt_if_error { service_controller.request(request, params) }
end

not_found do
  status 404
  redirect '/oops.html'
end
