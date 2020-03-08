# frozen_string_literal: true

require 'bundler/setup'
require 'pathname'

ROOT_DIR = Pathname(__dir__)

require_relative ROOT_DIR.join('lib', 'config')
Rake.add_rakelib 'tasks/**'

# Delete this namespace after successfully renaming the project
namespace :template do
  desc 'Rename the project'
  task :rename do
    raise 'No project name specified, append PROJECT=newname' if ENV['PROJECT'].nil?

    project = ENV['PROJECT'].strip.gsub(/\.rb$/, '')
    ROOT_DIR.join('rubyproject.rb').rename("#{project}.rb")
    [
      ROOT_DIR.join('config', 'schedule.example.rb'),
      ROOT_DIR.join('config', 'schedule.rb'),
      ROOT_DIR.join('config', 'config.example.yml'),
      ROOT_DIR.join('config', 'config.yml'),
      ROOT_DIR.join('lib', 'database.rb'),
      ROOT_DIR.join('tasks', 'db.rake')
    ].each do |file|
      next unless file.exist?

      content = File.read(file)
      File.write(file, content.gsub('rubyproject', project))
    end
  end
end
