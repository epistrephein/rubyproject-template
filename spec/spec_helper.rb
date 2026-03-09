# frozen_string_literal: true

require "bundler/setup"

ROOT_DIR = Pathname(__dir__).dirname.expand_path
$LOAD_PATH.unshift(ROOT_DIR) unless $LOAD_PATH.include?(ROOT_DIR)

require "lib/loader"
Loader.load!

RSpec.configure do |config|
  # Turn on all Ruby warnings
  config.warnings = :all

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Enable temporarily focused examples and groups
  config.filter_run_when_matching :focus

  # Use the documentation formatter for detailed output
  config.default_formatter = "doc"

  # Run specs in random order to surface order dependencies
  config.order = :random

  # Seed Ruby's global RNG with RSpec's seed for reproducibility
  Kernel.srand config.seed
end
