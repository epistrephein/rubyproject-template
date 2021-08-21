# frozen_string_literal: true

require 'bundler/setup'
require 'pathname'

ROOT_DIR = Pathname(__dir__).expand_path
$LOAD_PATH.unshift(ROOT_DIR) unless $LOAD_PATH.include?(ROOT_DIR)

task :environment do
  require 'lib/loader'
  Loader.load!
end

Rake.add_rakelib 'tasks/**'

task default: [:main]
