# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('post') do |routing|
      routing.on do
        # GET /post/{lab_id}/{post_id}
        routing.on String do |lab_id|
          routing.on String do |post_id|
            single_post = FetchPosts.new(App.config).single(lab_id, post_id)
            view :post, locals: { single_post: single_post }
          end
        end
      end
    end
  end
end