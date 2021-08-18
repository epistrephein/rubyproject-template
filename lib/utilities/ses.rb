# frozen_string_literal: true

require 'aws-sdk-ses'

module Ses
  extend Retryable

  EXCEPTIONS = [Aws::SES::Errors, Aws::Errors::NoSuchEndpointError].freeze

  ACCESS_KEY_ID     = Config[:aws, :ses, :access_key_id]
  SECRET_ACCESS_KEY = Config[:aws, :ses, :secret_access_key]
  REGION            = Config[:aws, :ses, :region]
  FROM_NAME         = Config[:aws, :ses, :from_name]
  FROM_EMAIL        = Config[:aws, :ses, :from_email]
  TO_EMAIL          = Config[:aws, :ses, :to_email]
  ENCODING          = Config[:aws, :ses, :encoding]

  CREDENTIALS = Aws::Credentials.new(ACCESS_KEY_ID, SECRET_ACCESS_KEY)
  CLIENT      = Aws::SES::Client.new(region: REGION, credentials: CREDENTIALS)

  class << self
    # Send an email to recipient(s).
    def send(to: TO_EMAIL, subject:, html:, text:, swallow_ex: false)
      with_retries(rescue_ex: EXCEPTIONS, swallow_ex: swallow_ex, delay: 5) do
        destination = { to_addresses: Array(to) }
        message     = {
          subject: { charset: ENCODING, data: subject },
          body:    { html: { charset: ENCODING, data: html },
                     text: { charset: ENCODING, data: text } }
        }

        CLIENT.send_email({
          destination: destination,
          message:     message,
          source:      "#{FROM_NAME} <#{FROM_EMAIL}>"
        })
      end
    end
  end
end
