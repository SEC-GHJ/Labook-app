# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('comment') do |routing|
      routing.on do
        # POST /comment/{comment_id}/votes/{vote_number}
        routing.on String do |comment_id|
          routing.on 'votes' do
            routing.on String do |vote_number|
              vote = CreateVote.new(App.config, @current_account)
                               .comment(comment_id:, vote_number:)

              redirect back
            rescue StandardError => e
              response.status = 500
              App.logger.warn e.message
              flash[:error] = 'Failed! Please try again later.'
              redirect back
            end
          end
        end
      end
    end
  end
end
