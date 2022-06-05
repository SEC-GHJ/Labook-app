# frozen_string_literal: true

module Labook
  module Form
    # Message
    class Message < Dry::Validation::Contract
      params do
        required(:content).filled
      end
    end
  end
end
