# frozen_string_literal: true

require_relative 'lab'

module Labook
  # Behaviors of the currently logged in account
  class Labs
    def self.call(labs_list)
      all = []
      labs_list.each do |labs|
        @labs = labs.map do |lab|
          Lab.new(lab)
        end
        all.push(@labs)
      end
      all
    end
  end
end
