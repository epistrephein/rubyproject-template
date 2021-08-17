# frozen_string_literal: true

require 'sequel'

class Database
  # Set database timezones.
  Sequel.database_timezone    = :utc
  Sequel.application_timezone = :local

  # Connect to the database.
  # MySQL
  ADAPTER  = :mysql2
  HOST     = Config[:mysql, :host]
  PORT     = Config[:mysql, :port]
  USERNAME = Config[:mysql, :username]
  PASSWORD = Config[:mysql, :password]
  DATABASE = Config[:mysql, :database]

  # PostgreSQL
  # ADAPTER  = :postgres
  # HOST     = Config[:postgres, :host]
  # PORT     = Config[:postgres, :port]
  # USERNAME = Config[:postgres, :username]
  # PASSWORD = Config[:postgres, :password]
  # DATABASE = Config[:postgres, :database]

  # SQLite
  # DB_FILE = ENV['SQLITE_FILE'] || File.join(__dir__, '..', 'db', 'rubyproject.sqlite')
  # DB      = Sequel.sqlite(DB_FILE)

  DB = Sequel.connect(
    adapter:  ADAPTER,
    host:     HOST,
    port:     PORT,
    username: USERNAME,
    password: PASSWORD,
    database: DATABASE
  )

  class << self
    def method_missing(method_name, arg = nil)
      return super unless respond_to_missing?(method_name)

      DB.public_send(method_name)
    end

    def respond_to_missing?(method_name, include_private = false)
      DB.respond_to?(method_name) || super
    end
  end
end
