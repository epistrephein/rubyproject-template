# frozen_string_literal: true

require 'aws-sdk-s3'
require 'base64'
require 'digest'

require_relative 'config'

AWS_ACCESS_KEY_ID     = ENV['AWS_ACCESS_KEY_ID']     || @config.dig('aws', 'access_key_id')
AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY'] || @config.dig('aws', 'secret_access_key')
AWS_REGION            = ENV['AWS_REGION']            || @config.dig('aws', 'region')
AWS_BUCKET            = ENV['AWS_BUCKET']            || @config.dig('aws', 'bucket')
AWS_PREFIX            = ENV['AWS_PREFIX']            || @config.dig('aws', 'prefix')

AWS_CREDENTIALS = Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
S3_CLIENT       = Aws::S3::Client.new(region: AWS_REGION, credentials: AWS_CREDENTIALS)

# Upload a file to a S3 bucket
def s3_put(file)
  retries ||= 3

  basename = File.basename(file)
  content  = File.read(file)
  digest   = Digest::MD5.digest(content)

  S3_CLIENT.put_object(
    bucket:      AWS_BUCKET,
    key:         File.join(AWS_PREFIX, basename),
    body:        content,
    content_md5: Base64.encode64(digest)
  )
rescue Aws::S3::Errors => e
  retry unless (retries -= 1).zero?
  raise e
end
