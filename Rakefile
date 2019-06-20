# frozen_string_literal: true

require 'bundler/setup'
require 'pathname'

ROOT_DIR = Pathname(__dir__)

# Delete this namespace after successfully renaming the project
namespace :template do
  desc 'Rename the project'
  task :rename do
    raise 'No project name specified' if ENV['PROJECT'].nil?

    project = ENV['PROJECT'].strip.gsub(/\.rb$/, '')
    ROOT_DIR.join('rubyproject.rb').rename("#{project}.rb")
    [
      ROOT_DIR.join('config', 'schedule.example.rb'),
      ROOT_DIR.join('config', 'config.example.yml'),
      ROOT_DIR.join('lib', 'database.rb'),
      ROOT_DIR.join('.ruby-gemset')
    ].each do |file|
      next unless file.exist?

      content = File.read(file)
      File.write(file, content.gsub('rubyproject', project))
    end
  end
end
