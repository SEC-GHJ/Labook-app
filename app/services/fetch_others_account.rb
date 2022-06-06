# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class FetchOthersAccount
    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call(other_account_id)
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .get("#{@config.API_URL}/accounts/#{other_account_id}")
      response.code == 200 ? response.parse : nil
    end
  end
end
