# frozen_string_literal: true

require 'fileutils'

namespace :db do
  DB_DIR   = ROOT_DIR.join('db')
  DUMP_DIR = DB_DIR.join('dump')

  # MySQL
  DB_HOST     = ENV['DB_HOST']     || @config.dig('database', 'host')
  DB_PORT     = ENV['DB_PORT']     || @config.dig('database', 'port')
  DB_USERNAME = ENV['DB_USERNAME'] || @config.dig('database', 'username')
  DB_PASSWORD = ENV['DB_PASSWORD'] || @config.dig('database', 'password')
  DB_NAME     = ENV['DB_NAME']     || @config.dig('database', 'database')

  # SQLite
  # DB_FILE  = ENV['DB_FILE'] || DB_DIR.join('rubyproject.sqlite')

  desc 'Create database'
  task :create do
    exec "mysql -u#{DB_USERNAME} #{'-p' + DB_PASSWORD unless DB_PASSWORD.empty?} -e" \
         "\"CREATE DATABASE #{DB_NAME} DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;\""
  end

  desc 'Dump database'
  task :dump do
    now       = Time.now.strftime('%Y%m%dT%H%M%S')
    dump_file = DUMP_DIR.join("rubyproject-#{now}.dump.gz")

    Dir.mkdir(DUMP_DIR) unless Dir.exist?(DUMP_DIR)

    puts "Dumping to: #{dump_file}"

    # MySQL
    exec "mysqldump -u#{DB_USERNAME} #{'-p' + DB_PASSWORD unless DB_PASSWORD.empty?} #{DB_NAME} | gzip -c > #{dump_file}"

    # SQLite
    # exec "sqlite3 #{DB_FILE} .dump | gzip -c > #{dump_file}"
  end
end
