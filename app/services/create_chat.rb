# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateChat
    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call(other_account:, content:)
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/chats/#{other_account}",
                           json: content)
      raise unless response.code == 200

      response.parse
    end
  end
end
