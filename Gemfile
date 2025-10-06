# frozen_string_literal: true

source "https://rubygems.org"

gem "irb", "~> 1.14"
gem "logger", "~> 1.7"
gem "rake", ">= 13.0"
gem "zeitwerk", "~> 2.4"

# Databases
gem "pg", "~> 1.5"
gem "sequel", "~> 5.40"
# gem 'mysql2', '~> 0.5'
# gem 'sqlite3', '~> 2.1'
# gem 'redis', '~> 5.0'

# Telegram
gem "telegram-bot-ruby", "~> 2.0"

# AWS
gem "aws-sdk-s3", "~> 1.90"
gem "aws-sdk-ses", "~> 1.40"
gem "base64", "~> 0.2"
gem "rexml", "~> 3.2"

group :production do
  gem "whenever", "~> 1.0", require: false
end

group :test do
  gem "rspec", "~> 3.10"
  gem "rubocop", "~> 1.50"
end

group :development do
  gem "dotenv"
  gem "webrick"
end
