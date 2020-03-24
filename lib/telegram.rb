# frozen_string_literal: true

# Optional notifications via Telegram
require 'telegram/bot'
require 'time'

require_relative 'config'

TELEGRAM_APP_NAME = ENV['TELEGRAM_APP_NAME'] || @config.dig('telegram', 'app_name')
TELEGRAM_TOKEN    = ENV['TELEGRAM_TOKEN']    || @config.dig('telegram', 'token')
TELEGRAM_USER     = ENV['TELEGRAM_USER']     || @config.dig('telegram', 'user')

# Send an exception as message via Telegram
def telegram_exception(exception, app_name: TELEGRAM_APP_NAME)
  text = <<~TXT
    🚧 *#{app_name}* exception 🚧

    `#{Time.now.iso8601}`
    `#{exception.class}`
    `#{exception.message}`
  TXT

  telegram_notification(text, swallow_exceptions: true)
end

# Send a message via Telegram
def telegram_notification(message, swallow_exceptions: false)
  bot = Telegram::Bot::Client.new(TELEGRAM_TOKEN)
  bot.api.send_message(
    chat_id:    TELEGRAM_USER,
    parse_mode: :markdown,
    text:       message
  )
rescue Telegram::Bot::Exceptions::Base => e
  retries ||= 3
  retry if (retries -= 1).positive?

  raise e unless swallow_exceptions
end
