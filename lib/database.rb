# frozen_string_literal: true

require 'sequel'

require_relative 'config'

# Set database timezones
Sequel.database_timezone    = :utc
Sequel.application_timezone = :local

# Connect to the database
# MySQL
DB_ADAPTER  = :mysql2
DB_HOST     = ENV['DB_HOST']     || @config.dig('mysql', 'host')     || '127.0.0.1'
DB_PORT     = ENV['DB_PORT']     || @config.dig('mysql', 'port')     || 3306
DB_USERNAME = ENV['DB_USERNAME'] || @config.dig('mysql', 'username') || 'root'
DB_PASSWORD = ENV['DB_PASSWORD'] || @config.dig('mysql', 'password') || ''
DB_NAME     = ENV['DB_NAME']     || @config.dig('mysql', 'database') || 'rubyproject'

# PostgreSQL
# DB_ADAPTER  = :postgres
# DB_HOST     = ENV['DB_HOST']     || @config.dig('postgres', 'host')     || '127.0.0.1'
# DB_PORT     = ENV['DB_PORT']     || @config.dig('postgres', 'port')     || 5432
# DB_USERNAME = ENV['DB_USERNAME'] || @config.dig('postgres', 'username') || 'root'
# DB_PASSWORD = ENV['DB_PASSWORD'] || @config.dig('postgres', 'password') || ''
# DB_NAME     = ENV['DB_NAME']     || @config.dig('postgres', 'database') || 'rubyproject'

DB = Sequel.connect(
  adapter:  DB_ADAPTER,
  host:     DB_HOST,
  port:     DB_PORT,
  username: DB_USERNAME,
  password: DB_PASSWORD,
  database: DB_NAME
)

# SQLite
# DB_FILE = ENV['DB_FILE'] || File.join(__dir__, '..', 'db', 'rubyproject.sqlite')
# DB      = Sequel.sqlite(DB_FILE)
