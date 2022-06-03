# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('messages') do |routing|
      @message_route = '/messages'

      all_chatrooms = FetchChatrooms.new(App.config, @current_account).call
      @chatrooms = Chatrooms.new(all_chatrooms)

      routing.is do
        routing.on do
          view :message, locals: { chatrooms: @chatrooms, messages: nil }
        end
      end

      routing.on String do |other_account|
        routing.get do
          all_messages = FetchMessages.new(App.config, @current_account).call(other_account:)
          messages = Messages.new(all_messages)
          view :message, locals: { chatrooms: @chatrooms, messages:,
                                   other_account:,
                                   account_id: @current_account.account_id }
        end

        routing.post do
          content = Form::Message.new.call(routing.params)

          if content.failure?
            routing.redirect "#{@message_route}/#{other_account}"
          end

          new_chat = CreateChat.new(App.config, @current_account)
                               .call(other_account:, **content.values)

          routing.redirect "#{@message_route}/#{other_account}"
        rescue StandardError => e
          response.status = 500
          routing.redirect @message_route
        end
      end
    end
  end
end
