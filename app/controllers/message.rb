# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('messages') do |routing|
      routing.on do
        chatrooms_json = FetchMessages.new(App.config, @current_account).call
        chatrooms = Chatrooms.new(chatrooms_json)
        view :message, locals: {chatrooms: chatrooms}
      end
    end
  end
end
