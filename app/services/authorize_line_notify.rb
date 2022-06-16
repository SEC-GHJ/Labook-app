# frozen_string_literal: true

require 'http'

module Labook
  # Post code to API
  class AuthorizeLineNotify
    # Error from Line
    class UnauthorizedLineError < StandardError
      def message
        'Could not connect with Line Notify'
      end
    end

    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call(code)
      message = { code: }
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/auth/line_notify_sso",
                           json: SignedMessage.sign(message))
      raise UnauthorizedLineError unless response.code == 200

      updated_account = JSON.parse(response.to_s)['data']['attributes']
      
      {
        account: updated_account['account']['attributes']
      }
    end
  end
end