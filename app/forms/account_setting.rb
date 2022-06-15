# frozen_string_literal: true

require 'dry-validation'

module Labook
  module Form
    # Setting param
    class AccountSetting < Dry::Validation::Contract
      params do
        required(:accept_mail).filled
        required(:show_all).filled
      end
    end
  end
end
