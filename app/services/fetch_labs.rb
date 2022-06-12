# frozen_string_literal: true

require 'http'
# GET api/v1/labs
module Labook
  # Returns all public labs
  class FetchLabs
    def initialize(config)
      @config = config
    end

    def call
      response = HTTP.get("#{@config.API_URL}/labs")
      raise unless response.code == 200

      response.parse['data']
    end

    def single(lab_id)
      response = HTTP.get("#{@config.API_URL}/labs/#{lab_id}")
      response.code == 200 ? response.parse : nil
    end
  end
end
