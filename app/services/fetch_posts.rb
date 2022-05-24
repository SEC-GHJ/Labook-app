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

    def single(lab_id, post_id)
      response = HTTP.get("#{@config.API_URL}/labs/#{lab_id}/posts/#{post_id}")
      raise unless response.code == 200

      response.parse
    end

  end
end
