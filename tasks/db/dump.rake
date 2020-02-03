# frozen_string_literal: true

require 'bundler/setup'
require 'fileutils'

namespace :db do
  DB_DIR   = ROOT_DIR.join('db')
  # DB_FILE  = DB_DIR.join('warehouse.sqlite')
  DUMP_DIR = DB_DIR.join('dump')

  desc 'Dump database'
  task :dump do
    now       = Time.now.utc.strftime('%Y%m%dT%H%M%S')
    dump_file = DUMP_DIR.join("warehouse-#{now}.dump.gz")

    Dir.mkdir(DUMP_DIR) unless Dir.exist?(DUMP_DIR)

    puts "Dumping to: #{dump_file}"
    # exec "sqlite3 #{DB_FILE} .dump | gzip -c > #{dump_file}"
  end
end
