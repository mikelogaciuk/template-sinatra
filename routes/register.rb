# frozen_string_literal: true

require 'sinatra/base'
require_relative '../utils/utils'
require_relative '../services/database'
require_relative '../helpers/helpers'

# This class represents the Register route for the Api API.
#
# The `Register` class inherits from `Sinatra::Base` and includes the `Database`
# and `Utils` modules. It also uses the `AuthHelper` module.
#
# The Register route allows a user to register himself by providing an email.
#
# The Register route returns a 201 status code and a token if the user is
# successfully registered. If the user already exists, it returns a 400 status
# code.
#
# The Register route is mounted on the `/api/register` path.
#
# The Register route is used in the `Api` class.
class Register < Sinatra::Base
  include Database
  include Utils
  helpers AuthHelper

  configure :development, :production do
    RubyVM::YJIT.enable
    enable :logging
  end

  # This route allows a user to register himself.
  # The user must provide an email.

  post '/api/register' do
    content_type :json
    email = params[:email]
    token = User.create(email)
    if token
      status 201
      { message: 'User registered successfully', token: token }.to_json
    else
      status 400
      { message: 'User already exists' }.to_json
    end
  end
end
