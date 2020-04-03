# frozen_string_literal: true

desc 'Main task'
task :main do |_task|
  require 'lib/database'

  puts 'This is a customizable rake task. Add your own logic here.'
end
