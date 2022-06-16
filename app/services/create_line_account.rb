# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateLineAccount
    # Error for accounts that cannot be created
    class InvalidAccount < StandardError
      def message = 'This account can no loger be created: please start again'
    end

    def initialize(config)
      @config = config
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    def call(profile_info:, line_info:)
      message = { 
                  email: line_info['email'],
                  username: profile_info['username'],
                  nickname: Base64.strict_encode64(profile_info['nickname']),
                  gpa: profile_info['gpa'],
                  ori_department: Base64.strict_encode64(profile_info['ori_department']),
                  ori_school: Base64.strict_encode64(profile_info['ori_school']),
                  line_id: line_info['line_id'],
                  show_all: false,
                  accept_mail: false
                }

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
