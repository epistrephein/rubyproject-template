# frozen_string_literal: true

source "https://rubygems.org"

gem "irb", "~> 1.17"
gem "logger", "~> 1.7"
gem "rake", ">= 13.0"
gem "zeitwerk", "~> 2.7"

# Databases
gem "pg", "~> 1.6"
gem "sequel", "~> 5.102"
# gem "mysql2", "~> 0.5"
# gem "sqlite3", "~> 2.9"
# gem "redis", "~> 5.4"

# Telegram
gem "telegram-bot-ruby", "~> 2.5"

# AWS
gem "aws-sdk-s3", "~> 1.215"
gem "aws-sdk-ses", "~> 1.96"
gem "base64", "~> 0.3"
gem "rexml", "~> 3.4"

group :production do
  gem "whenever", "~> 1.1", require: false
end

group :test do
  gem "rspec", "~> 3.13"
  gem "rubocop", "~> 1.85"
end

group :development do
  gem "dotenv"
  gem "webrick"
end
