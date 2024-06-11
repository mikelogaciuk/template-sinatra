# frozen_string_literal: true

require_relative '../database/config'
require_relative '../config/config'
require 'bcrypt'
require 'logger'

module Database
  class Users
    @logger = Logger.new($stdout)

    def self.seed
      begin
        DATABASE[:users].insert(id: 1,
                                email: MASTER_USER,
                                password: BCrypt::Password.create(MASTER_KEY),
                                role: 'admin',
                                is_active: 'true')
      rescue Sequel::DatabaseError
       @logger.info('Database already seeded with default admin user.')
      end
    end

    def self.find_by_email(email)
      DATABASE[:users].where(email:).first
    end

    def self.authenticate(email, password)
      user = find_by_email(email)
      return false if user.nil? || user[:password].nil? || user[:is_active] == 'false'

      BCrypt::Password.new(user[:password]) == password
    end

    def self.admin?(email)
      user = find_by_email(email)
      user[:role] == 'admin'
    end

    def self.user?(email)
      user = find_by_email(email)
      user[:role] == 'user'
    end

    def self.user_create(email, password)
      @logger.info("Creating user: #{email}")

      DATABASE[:users].insert(email: email,
                              password: BCrypt::Password.create(password),
                              role: 'user')
    end

    def self.user_delete!(email)
      DATABASE[:users].where(email: email).delete
    end

    def self.user_exists?(email)
      !DATABASE[:users].where(email: email).first.nil?
    end

    def self.users_list
      DATABASE[:users].select(:email, :role, :is_active).map(&:values)
    end

    def self.user_activate!(email)
      DATABASE[:users].where(email: email).update(is_active: 'true')
    end

    def self.user_deactivate!(email)
      DATABASE[:users].where(email: email).update(is_active: 'false')
    end

  end
end
