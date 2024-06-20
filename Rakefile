# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
desc 'Admin area'
namespace :admin do
  desc 'User management'
  namespace :user do
    require_relative 'services/database'
    require 'table_print'

    include Database

    desc 'List users'
    task :list do
      users = Database::User.list
      tp users, :email, :role, :is_active
    end

    desc 'Activate user'
    task :activate, [:email] do |_, args|
      if Database::User.activate!(args[:email])
        puts "User with email: #{args[:email]} has been activated."
      else
        puts "User with email: #{args[:email]} does not exist."
      end
    end

    desc 'Deactivate user'
    task :deactivate, [:email] do |_, args|
      if Database::User.deactivate!(args[:email])
        puts "User with email: #{args[:email]} has been deactivated."
      else
        puts "User with email: #{args[:email]} does not exist."
      end
    end

    desc 'Purge users'
    task :purge do
      Database::User.purge
      puts 'All users except admin have been purged.'
    end
  end
end

desc 'Database'
namespace :database do
  desc 'Destroy'
  task :destroy do
    system('rm ./database/local.db')
  end
end

desc 'Build'
namespace :build do
  desc 'Build Docker image'
  task :docker do
    system('docker compose build')
  end
end

desc 'Run API in different forms (docker, dev, prod)'
namespace :run do
  namespace :docker do
    desc 'Run Docker instance'
    task :up do
      system('docker compose up -d')
    end
    desc 'Teardown'
    task :destroy do
      system('docker compose down -v')
    end
  end

  desc 'Run foreman instance with sidekiq scheduler'
  task :scheduler do
    system('bundle exec foreman start')
  end
end
# rubocop:enable Metrics/BlockLength
