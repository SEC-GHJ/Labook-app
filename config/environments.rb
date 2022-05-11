# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'rack/ssl-enforcer'
require 'rack/session/redis'
require_relative '../require_app'

require_app('lib')

module Labook
  # Configuration for the API
  class App < Roda
    plugin :environments
    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    # Logger setup
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER

    configure do
      SecureMessage.setup(ENV.delete('MSG_KEY'))
    end

    configure :production do
      use Rack::SslEnforcer, hsts: true
    end
    configure :development, :test do
      require 'pry'
      # Allows running reload! in pry to restart entire app
      use Rack::Session::Pool,
          expire_after: ONE_MONTH

      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
