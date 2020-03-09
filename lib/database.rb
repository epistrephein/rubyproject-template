# frozen_string_literal: true

require 'sequel'

require_relative 'config'
require_relative 'logger'

# Set database timezones
Sequel.database_timezone    = :utc
Sequel.application_timezone = :local

# Connect to the database
# MySQL
DB = Sequel.mysql2(
  host:     ENV['DB_HOST']     || @config.dig('database', 'host')     || '127.0.0.1',
  port:     ENV['DB_PORT']     || @config.dig('database', 'port')     || 3306,
  username: ENV['DB_USERNAME'] || @config.dig('database', 'username') || 'root',
  password: ENV['DB_PASSWORD'] || @config.dig('database', 'password') || '',
  database: ENV['DB_NAME']     || @config.dig('database', 'database') || 'rubyproject',
  logger:   @db_log
)

# SQLite
# DB_FILE = ENV['DB_FILE'] || File.join(__dir__, '..', 'db', 'rubyproject.sqlite')
# DB      = Sequel.sqlite(DB_PATH)
