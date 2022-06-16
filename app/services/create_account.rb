# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateAccount
    # Error for accounts that cannot be created
    class InvalidAccount < StandardError
      def message = 'This account can no loger be created. Please start again'
    end

    def initialize(config)
      @config = config
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    def call(username:, nickname:, gpa:, ori_school:,
             ori_department:, password:, email:)
      message = { username:,
                  nickname: Base64.strict_encode64(nickname),
                  gpa:,
                  ori_school: Base64.strict_encode64(ori_school),
                  ori_department: Base64.strict_encode64(ori_department),
                  password:,
                  email:,
                  show_all: 0,
                  accept_mail: 0 }
      
      response = HTTP.post(
        "#{@config.API_URL}/accounts",
        json: SignedMessage.sign(message)
      )

      raise InvalidAccount unless response.code == 201
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/ParameterLists
  end
end
