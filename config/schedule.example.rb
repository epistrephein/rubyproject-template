# frozen_string_literal: true

job_type :ruby, 'cd :path && bundle exec ruby :task :output'

env :PATH, ENV['PATH']

set :chronic_options, hours24: true
set :output, error: 'log/stderr.log'

every 1.day, at: '10:30' do
  ruby 'rubyproject.rb'
end
