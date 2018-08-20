# frozen_string_literal: true

source 'https://rubygems.org'

gem 'activesupport'
gem 'dotenv'
gem 'json-schema'
gem 'oj'
gem 'rake'
gem 'sequel'
gem 'sequel_pg'
gem 'sinatra'

group :development do
  gem 'awesome_print'
  gem 'thin'
  gem 'yard'
  gem 'yard-sinatra', git: 'https://github.com/OwnLocal/yard-sinatra.git'
end

group :development, :test do
  gem 'factory_bot'
end

group :test do
  gem 'database_cleaner'
  gem 'rack-test'
  gem 'rspec'
  gem 'rubocop'
end

group :production do
  gem 'puma'
end
