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
          single_post = FetchPosts.new(App.config).single(post_id, @current_account)
          post = Post.new(single_post, giving_policies=true)
          view :post, locals: { single_post: post }
        end
        # GET /post
        routing.get do
          all_posts = FetchPosts.new(App.config).call
          posts = Posts.new(all_posts)
          view 'all_posts', locals: { current_account: @current_account,
            all_posts: posts,}
        end
      end
    end
  end
end
