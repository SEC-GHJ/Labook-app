# frozen_string_literal: true

require_relative 'chatroom'

module Labook
  # Behaviors of the all the chatrooms
  class Chatrooms
    attr_reader :all

    def initialize(chats_list)
      @all = chats_list.map do |chatroom|
        Chatroom.new(chatroom)
      end
    end
  end
end
