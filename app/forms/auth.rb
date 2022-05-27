# frozen_string_literal: true

require_relative 'form_base'

module Labook
  module Form
    # make a comment
    class LoginCredentials < Dry::Validation::Contract
      params do
        required(:account).filled
        required(:password).filled
      end
    end

    # Registration section
    class Registration < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/account_details.yml')

      params do
        required(:account).filled(format?: USERNAME_REGEX, min_size?: 4)
        required(:email).filled(format?: EMAIL_REGEX)
        required(:ori_school).filled(format?: SCHOOL_REGEX, min_size?: 3)
        required(:ori_department).filled(format?: DEPART_REGEX, min_size?: 2)
        required(:gpa).filled(format?: GPA_REGEX, min_size?: 1)
      end
    end

    # password section
    class Passwords < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/password.yml')

      params do
        required(:password).filled
        required(:password_confirm).filled
      end

      def enough_entropy?(string)
        StringSecurity.entropy(string) >= 3.0
      end

      rule(:password) do
        unless enough_entropy?(value)
          key.failure('Password must be more complex')
        end
      end

      rule(:password, :password_confirm) do
        unless values[:password].eql?(values[:password_confirm])
          key.failure('Passwords do not match')
        end
      end
    end
  end
end
