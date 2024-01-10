# frozen_string_literal: true

# Delete this rake file after successfully renaming the project.
namespace :template do
  desc 'Rename the project (PROJECT=newname)'
  task :rename do
    raise 'No project name specified' if ENV['PROJECT'].nil?

    project = ENV['PROJECT'].strip.downcase

    [
      ROOT_DIR.join('.github', 'samples', 'main.yml'),
      ROOT_DIR.join('config', 'config.example.yml'),
      ROOT_DIR.join('config', 'config.yml'),
      ROOT_DIR.join('lib', 'database.rb'),
      ROOT_DIR.join('tasks', 'db.rake'),
      ROOT_DIR.join('web', 'variables.yml')
    ].each do |file|
      next unless file.exist?

      content = File.read(file)
      File.write(file, content.gsub('rubyproject', project))
    end
  end
end
