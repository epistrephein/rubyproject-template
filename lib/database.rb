# frozen_string_literal: true

require 'sequel'

# Connect to the database
DB = Sequel.connect(
  adapter:  ENV['DB_ADAPTER']  || @config.dig('database', 'adapter')  || :mysql2,
  host:     ENV['DB_HOST']     || @config.dig('database', 'host')     || '127.0.0.1',
  port:     ENV['DB_PORT']     || @config.dig('database', 'port')     || 3306,
  username: ENV['DB_USERNAME'] || @config.dig('database', 'username') || 'root',
  password: ENV['DB_PASSWORD'] || @config.dig('database', 'password') || '',
  database: ENV['DB_NAME']     || @config.dig('database', 'database') || 'rubyproject',
  logger:   @db_log
)
