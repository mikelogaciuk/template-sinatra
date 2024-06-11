# frozen_string_literal: true

require 'sinatra/base'
require_relative '../utils/utils'
require_relative '../services/database'
require_relative '../helpers/helpers'

# The Admin class represents the routes and functionality for the admin section of the application.
# It includes various helper modules and defines routes for managing users.
class Admin < Sinatra::Base
  include Database
  include Utils
  helpers AuthHelper

  configure :development, :production do
    RubyVM::YJIT.enable
    enable :logging
  end

  get '/api/admin/users/list' do
    admin!
    content_type :json

    users = Database::Users.users_list.to_json

    status 200

    { users: users }.to_json
  end

  get '/api/admin/users/exists' do
    admin!
    content_type :json

    email = params[:email]

    status 200

    { exists: Database::Users.user_exists?(email) }.to_json
  end

  post '/api/admin/users/create' do
    admin!
    content_type :json

    email = params[:email]
    password = params[:password]

    if email.nil? || password.nil?
      status 400
      return { message: 'Email and password are required' }.to_json
    end

    if Database::Users.user_exists?(email)
      status 400
      return { message: 'User already exists' }.to_json
    else
      Database::Users.user_create(email, password)
      status 201
      { message: 'User created' }.to_json
    end
  end

  delete '/api/admin/users/delete' do
    admin!

    email = params[:email]

    if email.nil?
      status 400
      return { message: 'Email is required' }.to_json
    end

    if Database::Users.user_exists?(email)
      Database::Users.user_delete!(email)
      status 200
      { message: 'User deleted' }.to_json
    else
      status 404
      { message: 'User not found' }.to_json
    end
  end

  post '/api/admin/users/activate' do
    admin!
    email = params[:email]

    if email.nil?
      status 400
      return { message: 'Email is required' }.to_json
    end

    if Database::Users.user_exists?(email)
      Database::Users.user_activate!(email)
      status 200
      { message: 'User activated' }.to_json
    else
      status 404
      { message: 'User not found' }.to_json
    end
  end
end
