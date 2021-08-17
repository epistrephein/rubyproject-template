# frozen_string_literal: true

require 'yaml'

class Config
  CONFIG_FILE = File.join(__dir__, '..', 'config', 'config.yml')

  class << self
    def [](*args)
      strings = args.map(&:to_s)
      env_var = strings.join('_').upcase

      ENV[env_var] || configuration.dig(*strings)
    end
    alias at []

    private

    def configuration
      @configuration ||= load_and_validate!
    end

    def load_and_validate!
      config = YAML.load_file(ENV['CONFIG_FILE'] || CONFIG_FILE)

      required_keys = %w[mysql telegram aws:s3 aws:ses]
      missing_keys  = required_keys.reject { |k| config.dig(*k.split(':')) }

      unless missing_keys.empty?
        raise "Invalid config file, missing keys: #{missing_keys.join(', ')}"
      end

      config
    end
  end
end
