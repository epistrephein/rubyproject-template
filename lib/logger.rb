# frozen_string_literal: true

require 'logger'

class Logger
  LOG_DIR = File.join(__dir__, '..', 'log')

  class << self
    def stdout
      @stdout ||= ::Logger.new(loggers.first, 10, 1024000)
    end

    def stderr
      @stderr ||= ::Logger.new(loggers.last, 10, 1024000)
    end

    private

    def loggers
      if %w[1 true].include?(ENV['LOG_TO_FILE']&.downcase)
        stdout_log = ENV['STDOUT_LOG'] || File.join(LOG_DIR, 'stdout.log')
        stderr_log = ENV['STDERR_LOG'] || File.join(LOG_DIR, 'stderr.log')
      else
        stdout_log = $stdout
        stderr_log = $stderr
      end

      [stdout_log, stderr_log]
    end
  end
end
