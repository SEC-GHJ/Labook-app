# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateVote
    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def comment(comment_id:, vote_number:)
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/comments/#{comment_id}/votes",
                           json: {"number": vote_number})
      raise unless response.code == 200

      response.parse['attributes']
    end

    def post(post_id:, vote_number:)
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/posts/#{post_id}/votes",
                           json: {"number": vote_number})
      raise unless response.code == 200

      response.parse['attributes']
    end
  end
end
