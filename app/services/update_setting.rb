# frozen_string_literal: true

require 'http'

# GET api/v1/labs
module Labook
  # Update account setting
  class UpdateSetting
    class NoUpdate < StandardError; end

    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call(setting)
      message = {
        accept_mail: setting[:accept_mail],
        show_all: setting[:show_all]
      }
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .patch("#{@config.API_URL}/accounts/setting",
                           json: message)
      raise NoUpdate if response.code == 204
      raise unless response.code == 200

      response.parse['attributes']
    end
  end
end
