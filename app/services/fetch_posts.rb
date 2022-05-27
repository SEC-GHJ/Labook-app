# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class FetchPosts
    def initialize(config)
      @config = config
    end

    def call
      response = HTTP.get("#{@config.API_URL}/posts")
      raise unless response.code == 200

      response.parse['data']
    end

    def single(post_id)
      response = HTTP.get("#{@config.API_URL}/posts/#{post_id}")
      raise unless response.code == 200

      response.parse
    end

    def myPosts(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/posts/me")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
