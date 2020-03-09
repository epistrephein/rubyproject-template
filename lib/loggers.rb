# frozen_string_literal: true

require 'logger'

LOG_DIR    = File.join(__dir__, '..', 'log')
STDOUT_LOG = File.join(LOG_DIR, 'stdout.log')
STDERR_LOG = File.join(LOG_DIR, 'stderr.log')
DB_LOG     = File.join(LOG_DIR, 'database.log')

# Initialize loggers
@stdout = Logger.new(ENV['STDOUT_LOG'] || STDOUT_LOG, 10, 1024000)
@stderr = Logger.new(ENV['STDERR_LOG'] || STDERR_LOG, 10, 1024000)
@db_log = Logger.new(ENV['DB_LOG']     || DB_LOG,     10, 1024000)
