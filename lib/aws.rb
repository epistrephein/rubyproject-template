# frozen_string_literal: true

begin
  require 'aws-sdk-s3'

  AWS_ACCESS_KEY_ID     = ENV['AWS_ACCESS_KEY_ID']     || @config.dig('aws', 'access_key_id')
  AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY'] || @config.dig('aws', 'secret_access_key')
  AWS_REGION            = ENV['AWS_REGION']            || @config.dig('aws', 'region')
  AWS_BUCKET            = ENV['AWS_BUCKET']            || @config.dig('aws', 'bucket')
  AWS_PREFIX            = ENV['AWS_PREFIX']            || @config.dig('aws', 'prefix')

  AWS_CREDENTIALS = Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
  S3_CLIENT       = Aws::S3::Client.new(region: AWS_REGION, credentials: AWS_CREDENTIALS)

  def s3_put(file)
    basename = File.basename(file)
    content  = File.read(file)

    S3_CLIENT.put_object(
      bucket: AWS_BUCKET,
      key:    "#{AWS_PREFIX}#{basename}",
      body:   content
    )
  end
rescue LoadError
  nil
end
