# frozen_string_literal: true

# Optional notifications via Telegram
begin
  require 'telegram/bot'
  require 'time'

  require_relative 'config'

  TELEGRAM_APP   = ENV['TELEGRAM_APP']   || File.basename($PROGRAM_NAME, File.extname($PROGRAM_NAME))
  TELEGRAM_TOKEN = ENV['TELEGRAM_TOKEN'] || @config.dig('telegram', 'token')
  TELEGRAM_USER  = ENV['TELEGRAM_USER']  || @config.dig('telegram', 'user')

  def telegram_notification(message)
    return if TELEGRAM_TOKEN.nil? || TELEGRAM_USER.nil?

    bot = Telegram::Bot::Client.new(TELEGRAM_TOKEN)
    bot.api.send_message(
      chat_id:    TELEGRAM_USER,
      parse_mode: 'markdown',
      text:       message
    )
  end

  def telegram_exception(message, app: TELEGRAM_APP)
    text = <<~TXT
      🚧 *#{app}* exception 🚧

      `#{Time.now.iso8601}`
      `#{message}`
    TXT

    telegram_notification(text)
  end
rescue LoadError
  nil
end
