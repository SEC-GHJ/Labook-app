# frozen_string_literal: true

require 'http'

module Labook
  # Returns an authenticated user, or nil
  class CreateAccount
    class InvalidAccount < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(account:, password:, gpa:, ori_school:, ori_department:)
      message = { account: account,
                  password: password,
                  gpa: gpa,
                  ori_school: ori_school,
                  ori_department: ori_department }

      response = HTTP.post(
        "#{@config.API_URL}/accounts/",
        json: message
      )

      raise InvalidAccount unless response.code == 201
    end
  end
end
