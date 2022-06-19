# frozen_string_literal: true

require 'dry-validation'

module Labook
  module Form
    # Create new Post validation
    class Post < Dry::Validation::Contract
      params do
        # required(:lab_name)
        # required(:school_name).filled
        # required(:department_name).filled
        # required(:professor).filled
        required(:lab_score).filled
        required(:professor_attitude).filled
        required(:content).filled
      end

      rule(:lab_score) do
        key.failure('should be a number between 0 to 5') unless valid_score?(value)
      end

      def valid_score?(string)
        string.to_i >= 0 && string.to_i <= 5 && valid_int?(string)
      end

      def valid_int?(string)
        !!Integer(string)
      rescue ArgumentError
        false
      end
    end
  end
end
