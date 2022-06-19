# frozen_string_literal: true

require 'simplecov'

ENV['RACK_ENV'] = 'test'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'

require_relative 'test_load_all'

API_URL = app.config.API_URL
