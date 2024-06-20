# frozen_string_literal: true

require_relative '../database/config'
require_relative '../config/config'
require_relative '../utils/utils'
require 'bcrypt'
require 'logger'

# This module represents the database service for managing users in the system.
#
# The `Users` module includes the `Logger` class and provides methods for
# seeding the database, finding a user by email, authenticating a user, checking
# if a user is an admin, creating a user, deleting a user, listing users,
# activating a user, and deactivating a user.
#
module Database
  # This class represents a user in the system.
  class User
    include Utils
    @logger = Logger.new($stdout)

    def self.seed
      DATABASE[:users].insert(email: MASTER_USER,
                              token: BCrypt::Password.create(MASTER_KEY),
                              role: 'admin',
                              is_active: 'true')
    rescue Sequel::UniqueConstraintViolation
      @logger.info('Master user already exists.')
    rescue Sequel::DatabaseError => e
      @logger.error("Error seeding database: #{e.message}")
    end

    def self.find_by_email(email)
      DATABASE[:users].where(email: email).first
    end

    def self.create(email, role = 'user')
      token = Utils.generate_key
      DATABASE[:users].insert(email: email, token: BCrypt::Password.create(token), role: role, is_active: 'false')
      token
    rescue Sequel::UniqueConstraintViolation
      @logger.info("User with email: #{email} already exists.")
      false
    end

    def self.reset_password(email)
      token = Utils.generate_key
      if exists?(email)
        DATABASE[:users].where(email: email).update(token: BCrypt::Password.create(token))
        token
      else
        @logger.info("Can't reset password. User: #{email} does not exists.")
        false
      end
    end

    def self.delete(email)
      if exists?(email)
        DATABASE[:users].where(email: email).delete
        true
      else
        @logger.info("User with email: #{email} does not exist.")
        false
      end
    end

    def self.authenticate(email, token)
      user = find_by_email(email)
      return false if user.nil? || user[:token].nil? || user[:is_active] == 'false'

      BCrypt::Password.new(user[:token]) == token
    end

    def self.admin?(email)
      user = find_by_email(email)
      user[:role] == 'admin'
    end

    def self.user?(email)
      user = find_by_email(email)
      user[:role] == 'user'
    end

    def self.exists?(email)
      if find_by_email(email).nil?
        false
      else
        true
      end
    end

    def self.active?(email)
      user = find_by_email(email)
      user[:is_active] == 'true'

      true
    end

    def self.activate!(email)
      if exists?(email)
        DATABASE[:users].where(email: email).update(is_active: 'true')
        true
      else
        @logger.info("User with email: #{email} does not exist.")
        false
      end
    end

    def self.deactivate!(email)
      if exists?(email)
        DATABASE[:users].where(email: email).update(is_active: 'false')
        true
      else
        @logger.info("User with email: #{email} does not exist.")
        false
      end
    end

    def self.list
      DATABASE[:users].select(:email, :role, :is_active).all
    end

    def self.purge
      DATABASE[:users].exclude(email: MASTER_USER).delete
    end
  end
end
