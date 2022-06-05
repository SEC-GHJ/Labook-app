# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class FetchChatrooms
    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .get("#{@config.API_URL}/chats")
      raise unless response.code == 200

      response.parse
    end
  end
end