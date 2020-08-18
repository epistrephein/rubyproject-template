# frozen_string_literal: true

require 'telegram/bot'
require 'time'

require_relative 'config'
require_relative 'utilities'

TELEGRAM_EXCEPTIONS = [Telegram::Bot::Exceptions::Base, Faraday::Error].freeze

TELEGRAM_APP_NAME   = ENV['TELEGRAM_APP_NAME'] || @config.dig('telegram', 'app_name')
TELEGRAM_TOKEN      = ENV['TELEGRAM_TOKEN']    || @config.dig('telegram', 'token')
TELEGRAM_USER       = ENV['TELEGRAM_USER']     || @config.dig('telegram', 'user')

# Send an exception stacktrace as message via Telegram
def telegram_exception(exception, app_name: TELEGRAM_APP_NAME)
  text = <<~TXT
    🚧 *#{app_name}* exception 🚧

    `#{Time.now.iso8601}`
    `#{exception.class}`
    `#{exception.message}`
  TXT

  telegram_notification(text, swallow_ex: true)
end

# Send a message via Telegram
def telegram_notification(message, swallow_ex: false)
  with_retries(rescue_ex: TELEGRAM_EXCEPTIONS, swallow_ex: swallow_ex, delay: 1) do
    bot = Telegram::Bot::Client.new(TELEGRAM_TOKEN)
    bot.api.send_message(
      chat_id:    TELEGRAM_USER,
      parse_mode: :markdown,
      text:       message
    )
  end
end
