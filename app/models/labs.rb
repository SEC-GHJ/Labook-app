# frozen_string_literal: true

require_relative 'lab'

module Labook
  # Behaviors of the currently logged in account
  class Labs
    attr_reader :all

    def initialize(labs_list)
      @all = labs_list.map do |lab|
        Lab.new(lab)
      end
    end
  end
end
