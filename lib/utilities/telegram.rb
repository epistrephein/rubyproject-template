# frozen_string_literal: true

require 'telegram/bot'
require 'time'

module Telegram
  extend Retryable

  EXCEPTIONS = [Telegram::Bot::Exceptions::Base, Faraday::Error].freeze

  APP_NAME = Config[:telegram, :app_name]
  TOKEN    = Config[:telegram, :token]
  USER     = Config[:telegram, :user]&.to_i
  ENABLED  = !%w[0 false].include?(Config[:telegram, :enabled].to_s.downcase)

  class << self
    # Send a message via Telegram.
    def message(title, text, opts = {})
      body = <<~TXT
        #{header(title, **opts)}
        #{text}
      TXT

      call(body)
    end

    # Send an exception stacktrace as message via Telegram.
    def exception(exception)
      body = <<~TXT
        #{header('exception', type: :error)}

        `#{Time.now.iso8601}`
        `#{exception.class}`
        `#{exception.message}`
      TXT

      call(body, swallow_ex: true)
    end

    private

    def header(title, type: :info, emoji: nil)
      emoji ||= case type.to_sym
                when :info    then '💬'
                when :error   then '🚧'
                when :success then '🎉'
                when :urgent  then '📣'
                else               '💬'
                end

      "#{emoji} *#{APP_NAME}*: #{title} #{emoji}"
    end

    def call(text, swallow_ex: false)
      return false unless ENABLED

      with_retries(rescue_ex: EXCEPTIONS, swallow_ex: swallow_ex, delay: 1) do
        bot = Telegram::Bot::Client.new(TOKEN)
        bot.api.send_message(
          chat_id:    USER,
          parse_mode: :markdown,
          text:       text
        )
      end
    end
  end
end
