# frozen_string_literal: true

require 'yaml'

CONFIG_FILE = File.join(__dir__, '..', 'config', 'config.yml')

# Load the configuration file
@config = YAML.load_file(ENV['CONFIG_FILE'] || CONFIG_FILE)

# Validate the configuration keys
required_keys = %w[mysql telegram aws:s3 aws:ses]
missing_keys  = required_keys.reject { |k| @config.dig(*k.split(':')) }

unless missing_keys.empty?
  raise "Invalid config file, missing keys: #{missing_keys.join(', ')}"
end
