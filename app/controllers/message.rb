# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('messages') do |routing|
      @message_route = '/messages'

      all_chatrooms = FetchChatrooms.new(App.config, @current_account).call
      routing.redirect '/auth/logout' if all_chatrooms.nil?
      @chatrooms = Chatrooms.new(all_chatrooms)

      routing.is do
        routing.on do
          view :message, locals: { chatrooms: @chatrooms, messages: nil }
        end
      end

      routing.on String do |other_account_id|
        routing.on 'new' do
          CreateChatroom.new(App.config, @current_account).call(other_account_id:)

          routing.redirect "#{@message_route}/#{other_account_id}"
        rescue StandardError => e
          response.status = 500
          App.logger.warn e.message
          flash[:error] = 'Failed! Please try again later.'
          routing.redirect "/account/#{other_account_id}"
        end

        routing.get do
          other_username = @chatrooms.all.find { |chatroom| chatroom.account_id == other_account_id }.username
          all_messages = FetchMessages.new(App.config, @current_account).call(other_account_id:)
          messages = Messages.new(all_messages)
          view :message, locals: { chatrooms: @chatrooms, messages:,
                                   other_username:,
                                   other_account_id:,
                                   account_id: @current_account.account_id }
        end

        routing.post do
          content = Form::Message.new.call(routing.params)
          routing.redirect "#{@message_route}/#{other_account_id}" if content.failure?

          CreateChat.new(App.config, @current_account)
                    .call(other_account_id:, **content.values)

          routing.redirect "#{@message_route}/#{other_account_id}"
        rescue StandardError => e
          response.status = 500
          App.logger.warn e.message
          routing.redirect @message_route
        end
      end
    end
  end
end
