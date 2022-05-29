# frozen_string_literal: true

require_relative 'message'

module Labook
  # Behaviors of the all the chatrooms
  class Messages
    attr_reader :all

    def initialize(messages_list)
      @all = messages_list.map do |message|
        Message.new(message)
      end
    end
  end
end
