# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake', '>= 12.0'
gem 'zeitwerk', '~> 2.4'

group :database do
  gem 'sequel', '~> 5.40'

  gem 'mysql2', '~> 0.5'
  # gem 'pg', '~> 1.2'
  # gem 'sqlite3', '~> 1.4'

  # gem 'redis', '~> 4.0'
end

group :telegram do
  gem 'telegram-bot-ruby', '~> 1.0'
end

group :aws do
  gem 'aws-sdk-s3', '~> 1.90'
  gem 'aws-sdk-ses', '~> 1.40'
end

group :production do
  gem 'whenever', '~> 1.0', require: false
end

group :development do
  gem 'dotenv'
  gem 'pry'
  gem 'rubocop'
end
