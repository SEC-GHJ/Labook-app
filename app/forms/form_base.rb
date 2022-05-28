# frozen_string_literal: true

require 'dry-validation'

module Labook
  # Form helpers
  module Form
    USERNAME_REGEX = /^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*$/
    EMAIL_REGEX = /@/
    SCHOOL_REGEX = /[A-Z]/
    DEPART_REGEX = /[A-Z]/
    GPA_REGEX = /^[0-4]\.\d\d$/

    def self.validation_errors(validation)
      validation.errors.to_h.map { |k, v| [k, v].join(' ') }.join('; ')
    end

    def self.message_values(validation)
      validation.errors.to_h.values.join('; ')
    end
  end
end
