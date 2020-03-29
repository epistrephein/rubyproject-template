# frozen_string_literal: true

set :environment_variable, 'LOG_TO_FILE'
set :environment,          'true'

set :bundle_command,       '/usr/local/bin/bundle exec'
set :chronic_options,      hours24: true
set :output,               standard: 'log/stdout.log',
                           error:    'log/stderr.log'

every 1.day, at: '10:30' do
  rake 'main:task'
end

every 1.week, at: '02:30' do
  rake 'db:dump'
end

every 1.month, at: '04:30' do
  rake 'db:backup'
end
