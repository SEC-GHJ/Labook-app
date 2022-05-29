# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateAccount
    # Error for accounts that cannot be created
    class InvalidAccount < StandardError
      def message = 'This account can no loger be create: please start again'
    end

    def initialize(config)
      @config = config
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    def call(account:, gpa:, ori_school:,
             ori_department:, password:, email:)
      message = { account:,
                  gpa:,
                  ori_school:,
                  ori_department:,
                  password:,
                  email: }

      response = HTTP.post(
        "#{@config.API_URL}/accounts",
        json: message
      )

      raise InvalidAccount unless response.code == 201
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/ParameterLists
  end
end
