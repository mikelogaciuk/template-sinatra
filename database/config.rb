# frozen_string_literal: true

require 'sequel'
require 'sqlite3'
require_relative '../config/config'

DATABASE = Sequel.connect('sqlite://database/local.db')

DATABASE.create_table? :users do
  primary_key :id
  String :email, unique: true, not_null: true
  String :token, not_null: true
  String :role, default: 'user'
  String :is_active, default: 'false'
end
