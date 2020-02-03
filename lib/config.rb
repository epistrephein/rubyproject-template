# frozen_string_literal: true

require 'yaml'

CONFIG_FILE = File.join(__dir__, '..', 'config', 'config.yml')

# Load the configuration file
@config = YAML.load_file(ENV['CONFIG_FILE'] || CONFIG_FILE)

# Validate the configuration keys
required_keys = %w[database telegram]

unless (missing = required_keys - @config.keys) && missing.empty?
  raise "Invalid config file, missing keys: #{missing.join(', ')}"
end
