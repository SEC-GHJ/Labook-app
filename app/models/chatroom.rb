# frozen_string_literal: true

require_relative '../lib/calculate_duration'

module Labook
  # Behaviors of the all the chatrooms
  class Chatroom
    attr_reader :username, :nickname, :account_id,
                :newest_content, :last_seen

    def initialize(chat_info)
      @username = chat_info['attributes']['username']
      @nickname = chat_info['attributes']['nickname']
      @account_id = chat_info['attributes']['account_id']
      @newest_content = chat_info['include']['attributes']['content'] unless chat_info['include'].nil?
      created_at = Time.parse(chat_info['include']['attributes']['created_at']).strftime("%F %H:%M:%S") unless chat_info['include'].nil?
      @last_seen = CalculateDuration.duration(created_at)
    end
  end
end
