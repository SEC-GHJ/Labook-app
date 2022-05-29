# frozen_string_literal: true

module Labook
  # Behaviors of the all the chatrooms
  class Chatroom
    attr_reader :account

    def initialize(chat_info)
      @account = chat_info["attributes"]["account"]
    end
  end
end
