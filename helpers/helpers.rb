# frozen_string_literal: true

require 'json'
require_relative '../services/database'

module AuthHelper
  def admin!
    halt 401 unless authorized?
    halt 403 unless admin?
  end

  def admin?
    Database::Users.admin?(request.env['HTTP_USER'])
  end

  def protected!
    halt 401 unless authorized?
  end

  def authorized?
    user_token = request.env['HTTP_USER']
    user_password = request.env['HTTP_PASSWORD']

    Database::Users.authenticate(user_token, user_password)
  end
end
