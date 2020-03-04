# frozen_string_literal: true

require 'fileutils'

require_relative ROOT_DIR.join('lib', 'aws')

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
  # DB_FILE = ENV['DB_FILE'] || DB_DIR.join('rubyproject.sqlite')

  desc 'Dump database'
  task :dump do
    now       = Time.now.strftime('%Y%m%dT%H%M%S')
    dump_file = DUMP_DIR.join("rubyproject-#{now}.dump.gz")

    Dir.mkdir(DUMP_DIR) unless Dir.exist?(DUMP_DIR)

    # MySQL
    system "mysqldump -u#{DB_USERNAME} #{'-p' + DB_PASSWORD unless DB_PASSWORD.empty?} #{DB_NAME} | gzip -c > #{dump_file}"

    # SQLite
    # system "sqlite3 #{DB_FILE} .dump | gzip -c > #{dump_file}"

    puts "Dumping to: #{dump_file}"
  end

  desc 'Backup database to S3'
  task :backup do
    Rake::Task['db:dump'].invoke

    dump_file = FileList.new("#{DUMP_DIR}/*.gz").last
    s3_upload(dump_file)

    puts "Uploading to S3: #{dump_file}"
  end
end
