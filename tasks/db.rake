# frozen_string_literal: true

namespace :db do
  DB_DIR      = ROOT_DIR.join('db')
  DUMP_DIR    = DB_DIR.join('dump')
  MIGRATE_DIR = DB_DIR.join('migrate')

  desc 'Run migrations'
  task :migrate, [:version] do |_task, args|
    require 'sequel/core'

    Sequel.extension :migration
    version = args[:version].to_i if args[:version]

    Sequel::Migrator.run(Database::DB, MIGRATE_DIR, target: version)
  end

  desc 'View database version'
  task :version do |_task|
    puts Database::DB[:schema_info].first[:version]
  end

  desc 'Dump database'
  task :dump do |task|
    timestamp = Time.now.strftime('%Y%m%dT%H%M%S')
    dump_file = DUMP_DIR.join("rubyproject-#{timestamp}.dump.gz")

    Dir.mkdir(DUMP_DIR) unless Dir.exist?(DUMP_DIR)

    # MySQL
    command = []
    command << 'mysqldump'
    command << "-u #{Config[:mysql, :username]}"
    command << "-p #{Config[:mysql, :password]}" unless Config[:mysql, :password].empty?
    command << Config[:mysql, :database]
    command << "| gzip -c > #{dump_file}"

    # PostgreSQL
    # command = []
    # command << "PGPASSWORD=#{Config[:postgres, :password]}" unless Config[:postgres, :password].empty?
    # command << 'pg_dump'
    # command << "-U #{Config[:postgres, :username]}"
    # command << Config[:postgres, :database]
    # command << "| gzip -c > #{dump_file}"

    system command.join(' ')

    # SQLite
    # system "sqlite3 #{Database::DB_FILE} .dump | gzip -c > #{dump_file}"

    Logger.stdout.info(task) { "Dumping to #{dump_file}" }
  end

  desc 'Backup database to S3'
  task :backup do |task|
    Rake::Task['db:dump'].invoke

    dump_file = FileList.new(DUMP_DIR.join('*.gz')).last
    S3.put(dump_file)

    Logger.stdout.info(task) { "Uploading to S3 #{dump_file}" }
  end
end
