# frozen_string_literal: true

# Optional notifications via Telegram
begin
  require 'telegram/bot'
  require 'time'

  APP_NAME       = ENV['APP_NAME']       || File.basename($PROGRAM_NAME, File.extname($PROGRAM_NAME))
  TELEGRAM_TOKEN = ENV['TELEGRAM_TOKEN'] || @config.dig('telegram', 'token')
  TELEGRAM_USER  = ENV['TELEGRAM_USER']  || @config.dig('telegram', 'user')

  def telegram_notification(message)
    return if TELEGRAM_TOKEN.nil? || TELEGRAM_USER.nil?

    bot  = Telegram::Bot::Client.new(TELEGRAM_TOKEN)
    text = <<~TXT
      🚧 Exception on *#{APP_NAME}* 🚧

      `#{Time.now.iso8601}`
      `#{message}`
    TXT

    bot.api.send_message(
      chat_id:    TELEGRAM_USER,
      parse_mode: 'markdown',
      text:       text
    )
  end
rescue LoadError
  nil
end
