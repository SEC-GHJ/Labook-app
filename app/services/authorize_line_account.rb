# frozen_string_literal: true

require 'http'

module Labook
  # Post code to API
  class AuthorizeLineAccount
    # Error from Line
    class UnauthorizedLineError < StandardError
      def message
        'Could not register with Line'
      end
    end

    # if the account is not found
    class UserNotFound < StandardError
      def initialize(response)
        super
        @response = JSON.parse(response.to_s)
      end

      def message
        @response['message']
      end

      def line_register_url
        SecureMessage.encrypt(@response['user_info'])
      end
    end

    def initialize(config)
      @config = config
    end

    def call(code)
      message = { code: }
      response = HTTP.post("#{@config.API_URL}/auth/line_sso",
                           json: SignedMessage.sign(message))

      raise UserNotFound, response if response.code == 404
      raise UnauthorizedLineError unless response.code == 200

      account_info = JSON.parse(response.to_s)['data']['attributes']

      { account: account_info['account']['attributes'],
        auth_token: account_info['auth_token'] }
    end
  end
end
