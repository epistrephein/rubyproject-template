# frozen_string_literal: true

desc 'Main task'
task main: :environment do |task|
  Logger.stdout.info(task) { 'This is a customizable rake task. Add your own logic here.' }
rescue StandardError => e
  Telegram.exception(e)
  Logger.stderr.error(e.class) { e.full_message }
  exit(1)
end
