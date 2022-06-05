# frozen_string_literal: true

require 'http'
require 'uri'

module Labook
  # generate line auth url
  class GenerateLineNotifyAuth
    def initialize(config)
      @config = config
      @state = SecureRandom.hex(10)
    end

    def call
      # user open the notify choice
      data = {
        response_type: 'code',
        client_id: @config.LINE_NOTIFY_CHANNEL_ID,
        redirect_uri: @config.LINE_NOTIFY_REDIRECT_URI,
        scope: @config.LINE_NOTIFY_SCOPE,
        state: @state
      }
      query = URI.encode_www_form(data).gsub('+', '%20')
      "#{@config.LINE_NOTIFY_OAUTH_URL}?#{query}"
    end
  end
end
