# frozen_string_literal: true

require 'aws-sdk-s3'
require 'base64'
require 'digest'

module S3
  extend Retryable

  EXCEPTIONS = [Aws::S3::Errors, Aws::Errors::NoSuchEndpointError].freeze

  ACCESS_KEY_ID     = Config[:aws, :s3, :access_key_id]
  SECRET_ACCESS_KEY = Config[:aws, :s3, :secret_access_key]
  REGION            = Config[:aws, :s3, :region]
  BUCKET            = Config[:aws, :s3, :bucket]
  PREFIX            = Config[:aws, :s3, :prefix]

  CREDENTIALS = Aws::Credentials.new(ACCESS_KEY_ID, SECRET_ACCESS_KEY)
  CLIENT      = Aws::S3::Client.new(region: REGION, credentials: CREDENTIALS)

  class << self
    # Upload a file to a S3 bucket.
    def put(file, to: nil, swallow_ex: false)
      with_retries(rescue_ex: EXCEPTIONS, swallow_ex: swallow_ex, delay: 5) do
        basename    = File.basename(file)
        destination = to || basename
        content     = File.read(file)
        digest      = Digest::MD5.digest(content)

        CLIENT.put_object(
          bucket:      BUCKET,
          key:         File.join(PREFIX, destination),
          body:        content,
          content_md5: Base64.encode64(digest)
        )
      end
    end

    # Read a file from a S3 bucket.
    def get(path, to: nil, swallow_ex: false)
      with_retries(rescue_ex: EXCEPTIONS, swallow_ex: swallow_ex, delay: 5) do
        object = CLIENT.get_object(
          bucket: BUCKET,
          key:    File.join(PREFIX, path)
        )

        return object if to.nil?

        File.write(to, File.read(object.body.read))
      end
    end
  end
end
