# frozen_string_literal: true

require 'sinatra/base'
require_relative './utils/utils'
require_relative './services/database'
require_relative './helpers/helpers'
require_relative './routes/errors'
require_relative './routes/admin'

class Api < Sinatra::Base
  include Database
  include Utils
  helpers AuthHelper

  use Admin
  use Errors

  configure :development, :production do
    RubyVM::YJIT.enable
    enable :logging
    Database::Users.seed
  end

  get '/api/' do
    content_type :json
    status 200
    { message: 'Welcome to Hourly' }.to_json
  end

  post '/api/register' do
    content_type :json

    email = params[:email]
    password = params[:password]

    if Database::Users.user_exists?(email)
      status 400
      return { message: 'User already exists' }.to_json

    else
      Database::Users.user_create(email, password)
      status 201
      { message: 'User created' }.to_json
    end
  end

  get '/api/health' do
    content_type :json
    status 200
    { message: 'Healthy' }.to_json
  end

  get '/api/protected/*' do
    protected!
    content_type :json
    status 200
    { message: 'Welcome to the protected area' }.to_json
  end

  run! if app_file == Api
end
