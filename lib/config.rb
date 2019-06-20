# frozen_string_literal: true

require 'yaml'

# Load the configuration file
@config_file = File.join(__dir__, '..', 'config', 'config.yml')
@config      = YAML.load_file(@config_file)

# Validate the configuration keys
keys = %w[key1 key2 key3]

unless (missing = keys - @config.keys) && missing.empty?
  raise "Invalid config file, missing keys: #{missing.join(', ')}"
end
