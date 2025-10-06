# frozen_string_literal: true

require "yaml"

class Config
  CONFIG_FILE   = ENV["CONFIG_FILE"] || File.join(__dir__, "..", "config", "config.yml")
  REQUIRED_KEYS = %w[postgres telegram aws:s3 aws:ses].freeze

  class << self
    def [](*args)
      strings = args.map(&:to_s)
      env_var = strings.join("_").upcase

      ENV[env_var] || configuration.dig(*strings)
    end

    private

    def configuration
      @configuration ||= load_and_validate!
    end

    def load_and_validate!
      config       = YAML.load_file(CONFIG_FILE)
      missing_keys = REQUIRED_KEYS.reject { |k| config.dig(*k.split(":")) }

      unless missing_keys.empty?
        raise "Invalid config file, missing keys: #{missing_keys.join(', ')}"
      end

      config
    end
  end
end
