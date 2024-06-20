# frozen_string_literal: true

require 'json'
require 'sequel'
require_relative '../services/database'

# This module provides helper methods for authentication.
#
# There are few available methods:
#
# The `admin!` method checks if the user is an admin.
#
# The `admin?` method checks if the user is an admin.
#
# The `protected!` method checks if the user is authorized.
#
# The `authorized?` method checks if the user is authorized.
#
# The `authenticate` method authenticates the user.
module AuthHelper
  def admin!
    halt 401 unless authorized?
    halt 403 unless admin?
  end

  def admin?
    Database::User.admin?(request.env['HTTP_EMAIL'])
  end

  def protected!
    halt 401 unless authorized?
  end

  def authorized?
    email = request.env['HTTP_EMAIL']
    token = request.env['HTTP_TOKEN']

    Database::User.authenticate(email, token)
  end
end
