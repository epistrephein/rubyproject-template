# frozen_string_literal: true

require 'aws-sdk-s3'
require 'base64'
require 'digest'

require_relative 'config'
require_relative 'utilities'

S3_EXCEPTIONS        = [Aws::S3::Errors, Aws::Errors::NoSuchEndpointError].freeze

S3_ACCESS_KEY_ID     = ENV['S3_ACCESS_KEY_ID']     || @config.dig('aws', 's3', 'access_key_id')
S3_SECRET_ACCESS_KEY = ENV['S3_SECRET_ACCESS_KEY'] || @config.dig('aws', 's3', 'secret_access_key')
S3_REGION            = ENV['S3_REGION']            || @config.dig('aws', 's3', 'region')
S3_BUCKET            = ENV['S3_BUCKET']            || @config.dig('aws', 's3', 'bucket')
S3_PREFIX            = ENV['S3_PREFIX']            || @config.dig('aws', 's3', 'prefix')

S3_CREDENTIALS = Aws::Credentials.new(S3_ACCESS_KEY_ID, S3_SECRET_ACCESS_KEY)
S3_CLIENT      = Aws::S3::Client.new(region: S3_REGION, credentials: S3_CREDENTIALS)

# Upload a file to a S3 bucket
def s3_put(file, swallow_ex: false)
  with_retries(rescue_ex: S3_EXCEPTIONS, swallow_ex: swallow_ex, delay: 5) do
    basename = File.basename(file)
    content  = File.read(file)
    digest   = Digest::MD5.digest(content)

    S3_CLIENT.put_object(
      bucket:      S3_BUCKET,
      key:         File.join(S3_PREFIX, basename),
      body:        content,
      content_md5: Base64.encode64(digest)
    )
  end
end
