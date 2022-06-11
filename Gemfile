# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web
gem 'puma'
gem 'roda'
gem 'slim'
gem 'sinatra'

# Configuration
gem 'figaro'
gem 'rake'

# Debugging
gem 'pry'
gem 'rack-test'

# Communication
gem 'http'
gem 'redis'
gem 'redis-rack'

# Security
gem 'dry-validation'
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed

# Time format
gem 'time_difference'

# Development
group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'webmock'
end

group :development, :test do
  gem 'rerun'
end
