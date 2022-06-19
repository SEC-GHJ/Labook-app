# frozen_string_literal: true

require 'http'

# Currently not use!!
module Labook
  # Returns an new created lab
  class CreateLab
    # Can not find lab
    class FindLabError < StandardError
      def message = 'Can not find or create Lab'
    end

    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    # rubocop:disable Metrics/MethodLength
    def call(params)
      message = {
        lab_name: params[:lab_name],
        school: params[:school_name],
        department: params[:department_name],
        professor: params[:professor]
      }

      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/labs",
                           json: message)
      raise FindLabError if response.code > 400

      Lab.new(response.parse['data'])
    end
    # rubocop:enable Metrics/MethodLength
  end
end
