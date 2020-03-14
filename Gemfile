# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rake',    '>= 12.0'
gem 'sequel',  '~> 5.26'

gem 'mysql2',  '~> 0.5'
# gem 'pg',      '~> 1.2'
# gem 'sqlite3', '~> 1.4'

group :aws do
  gem 'aws-sdk-s3', '~> 1.60'
end

group :telegram do
  gem 'telegram-bot-ruby', '~> 0.12'
end

group :production do
  gem 'whenever', '~> 1.0', require: false
end

group :development do
  gem 'awesome_print'
  gem 'dotenv'
  gem 'pry-byebug'
  gem 'rainbow'
  gem 'rubocop'
end
