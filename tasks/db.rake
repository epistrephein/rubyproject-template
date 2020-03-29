# frozen_string_literal: true

require 'fileutils'

namespace :db do
  DB_DIR   = ROOT_DIR.join('db')
  DUMP_DIR = DB_DIR.join('dump')

  desc 'Dump database'
  task :dump do |task|
    require ROOT_DIR.join('lib', 'database')

    timestamp = Time.now.strftime('%Y%m%dT%H%M%S')
    dump_file = DUMP_DIR.join("rubyproject-#{timestamp}.dump.gz")

    Dir.mkdir(DUMP_DIR) unless Dir.exist?(DUMP_DIR)

    # MySQL
    system "mysqldump -u#{DB_USERNAME} #{'-p' + DB_PASSWORD unless DB_PASSWORD.empty?} #{DB_NAME} | gzip -c > #{dump_file}"

    # PostgreSQL
    # system "#{'PGPASSWORD=' + DB_PASSWORD unless DB_PASSWORD.empty?} pg_dump -U #{DB_USERNAME} #{DB_NAME} | gzip -c > #{dump_file}"

    # SQLite
    # system "sqlite3 #{DB_FILE} .dump | gzip -c > #{dump_file}"

    @stdout.info(task) { "Dumping to: #{dump_file}" }
  end

  desc 'Backup database to S3'
  task :backup do |task|
    require ROOT_DIR.join('lib', 'aws_s3')

    Rake::Task['db:dump'].invoke

    dump_file = FileList.new(DUMP_DIR.join('*.gz')).last
    s3_put(dump_file)

    @stdout.info(task) { "Uploading to S3: #{dump_file}" }
  end
end
