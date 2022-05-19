# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end
    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(account:, password:)
      response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                           json: { account:, password: })
      raise(UnauthorizedError) if response.code == 403
      raise(ApiServerError) if response.code != 200

      account_info = JSON.parse(respones.to_s)['attributes']

      { account: account_info['account']['attributes'],
        auth_token: account_info['autho_token'] }
    rescue HTTP::ConnectionError
      raise ApiServerError
    end
  end
end
