# frozen_string_literal: true

require 'sequel'

# Connect to the database
DB = Sequel.connect(
  adapter:  :mysql2,
  host:     ENV['DB_HOST']     || @config.dig('mysql', 'host')     || '127.0.0.1',
  port:     ENV['DB_PORT']     || @config.dig('mysql', 'port')     || 3306,
  username: ENV['DB_USERNAME'] || @config.dig('mysql', 'username') || 'root',
  password: ENV['DB_PASSWORD'] || @config.dig('mysql', 'password') || '',
  database: ENV['DB_NAME']     || @config.dig('mysql', 'database') || 'rubyproject'
)
