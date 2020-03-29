# frozen_string_literal: true

require 'logger'

LOG_DIR = File.join(__dir__, '..', 'log')

# Set log target to file or stdout/stderr
if %w[1 true].include?(ENV['LOG_TO_FILE']&.downcase)
  STDOUT_LOG = ENV['STDOUT_LOG'] || File.join(LOG_DIR, 'stdout.log')
  STDERR_LOG = ENV['STDERR_LOG'] || File.join(LOG_DIR, 'stderr.log')
else
  STDOUT_LOG = $stdout
  STDERR_LOG = $stderr
end

# Initialize loggers
@stdout = Logger.new(STDOUT_LOG, 10, 1024000)
@stderr = Logger.new(STDERR_LOG, 10, 1024000)
