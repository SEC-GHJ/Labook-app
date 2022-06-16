# frozen_string_literal: true

require 'http'
# GET api/v1/labs
module Labook
  # Returns all public labs
  class FetchLabs
    def initialize(config)
      @config = config
    end

    def call(current_account)
      if current_account.logged_in?
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/labs")
      else
        response = HTTP.get("#{@config.API_URL}/labs")
      end
      response.code == 200 ? response.parse : nil
    end

    def single(lab_id, current_account)
      if current_account.logged_in?
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/labs/#{lab_id}")
      else
        response = HTTP.get("#{@config.API_URL}/labs/#{lab_id}")
      end
      response.code == 200 ? response.parse : nil
    end

    def lab_posts(lab_id, current_account)
      if current_account.logged_in?
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .get("#{@config.API_URL}/labs/#{lab_id}/posts")
      else
        response = HTTP.get("#{@config.API_URL}/labs/#{lab_id}/posts")
      end
      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
