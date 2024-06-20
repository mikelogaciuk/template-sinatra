# frozen_string_literal: true

require 'sinatra/base'
require_relative './utils/utils'
require_relative './services/database'
require_relative './helpers/helpers'
require_relative './routes/error'
# require_relative './routes/admin'
require_relative './routes/register'

# This class represents the main application for the Api API.

# The `Api` class inherits from `Sinatra::Base` and includes the `Database`
# and `Utils` modules. It also uses the `Admin` and `Errors` classes.
#
# The main application includes the `/api/` route, a health check route, and
# a protected route.
#
# The main application also configures the `RubyVM::YJIT` compiler in development
# and production environments.
class Api < Sinatra::Base
  include Database
  include Utils
  helpers AuthHelper

  # use Admin
  use Error
  use Register

  configure :development, :production do
    RubyVM::YJIT.enable
    enable :logging
    Database::User.seed
  end

  get '/api/' do
    content_type :json
    status 200
    { message: 'Welcome to Api' }.to_json
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
