# frozen_string_literal: true

require "sequel"
# require "redis"

class Database
  # Set database timezones.
  Sequel.database_timezone    = :utc
  Sequel.application_timezone = :local

  # Connect to the database.
  # PostgreSQL
  ADAPTER  = :postgres
  HOST     = Config[:postgres, :host]
  PORT     = Config[:postgres, :port]
  USERNAME = Config[:postgres, :username]
  PASSWORD = Config[:postgres, :password]
  DATABASE = Config[:postgres, :database]

  # MySQL
  # ADAPTER  = :mysql2
  # HOST     = Config[:mysql, :host]
  # PORT     = Config[:mysql, :port]
  # USERNAME = Config[:mysql, :username]
  # PASSWORD = Config[:mysql, :password]
  # DATABASE = Config[:mysql, :database]

  # SQLite
  # DB_FILE = ENV["SQLITE_FILE"] || File.join(__dir__, "..", "db", "rubyproject.sqlite")
  # DB      = Sequel.sqlite(DB_FILE)

  # Redis
  # HOST     = Config[:redis, :host]
  # PORT     = Config[:redis, :port]
  # DATABASE = Config[:redis, :database]
  # DB       = Redis.new(host: HOST, port: PORT, db: DATABASE)

  DB = Sequel.connect(
    ENV["DATABASE_URL"] || {
      adapter:  ADAPTER,
      host:     HOST,
      port:     PORT,
      username: USERNAME,
      password: PASSWORD,
      database: DATABASE
    }
  )

  class << self
    def method_missing(method_name, *args, **kwargs)
      return super unless respond_to_missing?(method_name)

      DB.public_send(method_name, *args, **kwargs)
    end

    def respond_to_missing?(method_name, include_private = false)
      DB.respond_to?(method_name) || super
    end
  end
end
