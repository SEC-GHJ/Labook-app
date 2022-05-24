# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('post') do |routing|
      routing.on do
        # GET /post/{post_id}
        routing.on String do |post_id|
          single_post = FetchPosts.new(App.config).single(post_id)
          post = Post.new(single_post)
          view :post, locals: { single_post: post}
        end
      end
    end
  end
end
