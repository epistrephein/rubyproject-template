# frozen_string_literal: true

desc "Main task"
task main: :environment do |task|
  Log.stdout.info(task) { "This is a customizable rake task. Add your own logic here." }
rescue StandardError => e
  Telegram.exception(e)
  Log.stderr.error(e.class) { e.message }
  exit(1)
end
