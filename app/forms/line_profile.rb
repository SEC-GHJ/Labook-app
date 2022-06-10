# frozen_string_literal: true

module Labook
  module Form
    # Registration with line account
    class LineProfile < Dry::Validation::Contract
      params do
        required(:nickname).filled
        required(:gpa).filled
        required(:ori_department).filled
        required(:ori_school).filled
        required(:username).filled
      end
    end
  end
end
