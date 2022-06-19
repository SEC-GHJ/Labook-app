# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateComment
    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call(post_id:, content:)
      content = {
        content:,
        vote_sum: '0'
      }
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/posts/#{post_id}/comments",
                           json: content)
      raise unless response.code == 200

      response.parse
    end
  end
end
