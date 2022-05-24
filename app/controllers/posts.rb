# frozen_string_literal: true

require 'roda'

module Labook
  # Web controller for Credence API
  class App < Roda
    route('posts') do |routing|
      routing.on do
        # GET /posts
        routing.get do
          if @current_account.logged_in?
            posts_list = GetAllPosts.new(App.config).call(@current_account)

            posts = Posts.new(posts_list)

            view :posts_list,
                 locals: { current_account: @current_account, posts: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
