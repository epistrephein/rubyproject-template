# frozen_string_literal: true

job_type :ruby, 'cd :path && :bundle_command exec ruby :task :output'

set :bundle_command, '/usr/local/bin/bundle'
set :chronic_options, hours24: true
set :output, error: 'log/stderr.log'

every 1.day, at: '10:30' do
  ruby 'rubyproject.rb'
end
