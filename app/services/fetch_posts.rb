# frozen_string_literal: true

require 'http'

module Labook
  # Returns all public posts
  class FetchPosts
    def initialize(config)
      @config = config
    end

    def call
      response = HTTP.get("#{@config.API_URL}/posts")
      raise unless response.code == 200

      response.parse['data']
    end

    def single(post_id, current_account)
      if current_account.logged_in?
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/posts/#{post_id}")
      else
        response = HTTP.get("#{@config.API_URL}/posts/#{post_id}")
      end
      response.code == 200 ? response.parse : nil
    end

    def my_posts(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/posts/me")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
