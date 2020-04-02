# frozen_string_literal: true

desc 'Main task'
task :main do |_task|
  require 'lib/database'

  puts 'This is the main rake task.'
end
