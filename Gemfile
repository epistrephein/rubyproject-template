# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake', '>= 12.0'
gem 'zeitwerk', '~> 2.4'

# Databases
gem 'sequel', '~> 5.40'
gem 'mysql2', '~> 0.5'
# gem 'pg', '~> 1.2'
# gem 'sqlite3', '~> 1.4'
# gem 'redis', '~> 4.0'

# Telegram
gem 'telegram-bot-ruby', '~> 1.0'

# AWS
gem 'aws-sdk-s3', '~> 1.90'
gem 'aws-sdk-ses', '~> 1.40'

group :production do
  gem 'whenever', '~> 1.0', require: false
end

group :development do
  gem 'dotenv'
  gem 'pry'
  gem 'rubocop'
end
