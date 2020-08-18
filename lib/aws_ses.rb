# frozen_string_literal: true

require 'aws-sdk-ses'

require_relative 'config'
require_relative 'utilities'

SES_EXCEPTIONS        = [Aws::SES::Errors, Aws::Errors::NoSuchEndpointError].freeze

SES_ACCESS_KEY_ID     = ENV['SES_ACCESS_KEY_ID']     || @config.dig('aws', 'ses', 'access_key_id')
SES_SECRET_ACCESS_KEY = ENV['SES_SECRET_ACCESS_KEY'] || @config.dig('aws', 'ses', 'secret_access_key')
SES_REGION            = ENV['SES_REGION']            || @config.dig('aws', 'ses', 'region')
SES_FROM_NAME         = ENV['SES_FROM_NAME']         || @config.dig('aws', 'ses', 'from_name')
SES_FROM_EMAIL        = ENV['SES_FROM_EMAIL']        || @config.dig('aws', 'ses', 'from_email')
SES_TO_EMAIL          = ENV['SES_TO_EMAIL']          || @config.dig('aws', 'ses', 'to_email')
SES_ENCODING          = ENV['SES_ENCODING']          || 'UTF-8'

SES_CREDENTIALS = Aws::Credentials.new(SES_ACCESS_KEY_ID, SES_SECRET_ACCESS_KEY)
SES_CLIENT      = Aws::SES::Client.new(region: SES_REGION, credentials: SES_CREDENTIALS)

# Send an email to recipient(s)
def ses_send(to: SES_TO_EMAIL, subject:, html:, text:, swallow_ex: false)
  with_retries(rescue_ex: SES_EXCEPTIONS, swallow_ex: swallow_ex, delay: 5) do
    destination = { to_addresses: Array(to) }
    message     = {
      subject: { charset: SES_ENCODING, data: subject },
      body:    { html: { charset: SES_ENCODING, data: html },
                 text: { charset: SES_ENCODING, data: text } }
    }

    SES_CLIENT.send_email({
      destination: destination,
      message:     message,
      source:      "#{SES_FROM_NAME} <#{SES_FROM_EMAIL}>"
    })
  end
end
