# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake', '>= 13.0'
gem 'zeitwerk', '~> 2.4'

# Databases
gem 'mysql2', '~> 0.5'
gem 'sequel', '~> 5.40'
# gem 'pg', '~> 1.2'
# gem 'sqlite3', '~> 1.4'
# gem 'redis', '~> 4.0'

# Telegram
gem 'telegram-bot-ruby', '~> 2.0'

# AWS
gem 'aws-sdk-s3', '~> 1.90'
gem 'aws-sdk-ses', '~> 1.40'
gem 'rexml', '~> 3.2'

group :production do
  gem 'whenever', '~> 1.0', require: false
end

group :test do
  gem 'rspec', '~> 3.10'
  gem 'rubocop', '~> 1.50'
end

group :development do
  gem 'dotenv'
  gem 'irb'
  gem 'webrick'
end
