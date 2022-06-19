# frozen_string_literal: true

require_relative 'form_base'

module Labook
  module Form
    # Login Credentials
    class LoginCredentials < Dry::Validation::Contract
      params do
        required(:username).filled
        required(:password).filled
      end
    end

    # Registration
    class Registration < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/account_details.yml')

      params do
        required(:username).filled(format?: USERNAME_REGEX, min_size?: 4)
        required(:email).filled(format?: EMAIL_REGEX)
      end
    end

    # Registration
    class Profile < Dry::Validation::Contract
      params do
        required(:nickname).filled
        required(:gpa).filled
        required(:ori_department).filled
        required(:ori_school).filled
      end
      rule(:gpa) do
        key.failure('should be a number between 0.0 to 4.3') unless valid_gpa?(value)
      end

      def valid_gpa?(string)
        string.to_f >= 0 && string.to_f <= 4.3 && valid_float?(string)
      end

      def valid_float?(string)
        !!Float(string)
      rescue ArgumentError
        false
      end
    end

    # Passwords
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
        key.failure('Password must be more complex') unless enough_entropy?(value)
      end

      rule(:password, :password_confirm) do
        key.failure('Passwords do not match') unless values[:password].eql?(values[:password_confirm])
      end
    end
  end
end
