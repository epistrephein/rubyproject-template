# frozen_string_literal: true

require 'sequel'

require_relative 'config'
require_relative 'loggers'

# Set database timezones
Sequel.database_timezone    = :utc
Sequel.application_timezone = :local

# Connect to the database
# MySQL
DB = Sequel.mysql2(
  host:     ENV['DB_HOST']     || @config.dig('mysql', 'host')     || '127.0.0.1',
  port:     ENV['DB_PORT']     || @config.dig('mysql', 'port')     || 3306,
  username: ENV['DB_USERNAME'] || @config.dig('mysql', 'username') || 'root',
  password: ENV['DB_PASSWORD'] || @config.dig('mysql', 'password') || '',
  database: ENV['DB_NAME']     || @config.dig('mysql', 'database') || 'rubyproject',
  logger:   @db_log
)

# PostgreSQL
# DB = Sequel.postgres(
#   host:     ENV['DB_HOST']     || @config.dig('postgres', 'host')     || '127.0.0.1',
#   port:     ENV['DB_PORT']     || @config.dig('postgres', 'port')     || 5432,
#   username: ENV['DB_USERNAME'] || @config.dig('postgres', 'username') || 'root',
#   password: ENV['DB_PASSWORD'] || @config.dig('postgres', 'password') || '',
#   database: ENV['DB_NAME']     || @config.dig('postgres', 'database') || 'rubyproject',
#   logger:   @db_log
# )

# SQLite
# DB_FILE = ENV['DB_FILE'] || File.join(__dir__, '..', 'db', 'rubyproject.sqlite')
# DB      = Sequel.sqlite(DB_FILE, logger: @db_log)
