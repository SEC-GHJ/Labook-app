# frozen_string_literal: true

require_relative 'message'
require_relative '../lib/calculate_duration'

module Labook
  # Behaviors of the all the chatrooms
  class Messages
    attr_reader :all, :last_seen

    def initialize(messages_list)
      @all = messages_list.map do |message|
        Message.new(message)
      end

      # @last_seen = all.last.nil? ? nil : CalculateDuration.duration(all.last.created_at)
      @last_seen = CalculateDuration.duration(all.last.created_at)
    end
  end
end
