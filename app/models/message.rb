# frozen_string_literal: true

module Labook
  # Behaviors of the all the chatrooms
  class Message
    attr_reader :content, :created_at, :sender_id

    def initialize(message_info)
      @chat_id = message_info['attributes']['chat_id']
      @content = message_info['attributes']['content']
      @created_at = Time.parse(message_info['attributes']['created_at'])
                        .strftime('%F %H:%M:%S')
      @sender_id = message_info['attributes']['sender_id']
    end
  end
end
