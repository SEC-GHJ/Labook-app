# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('post') do |routing|
      routing.on do
        routing.on String do |post_id|
          # POST /post/{post_id}/votes/{vote_number}
          routing.on 'votes' do
            routing.on String do |vote_number|
              CreateVote.new(App.config, @current_account)
                        .post(post_id:, vote_number:)
              redirect back
            rescue StandardError => e
              response.status = 500
              App.logger.warn e.message
              flash[:error] = 'Failed! Please try again later.'
              redirect back
            end
          end

          # POST /post/{post_id}
          routing.post do
            content = Form::Message.new.call(routing.params)
            routing.redirect "/post/#{post_id}" if content.failure?

            CreateComment.new(App.config, @current_account)
                         .call(post_id:, **content.values)
            routing.redirect "/post/#{post_id}"
          rescue StandardError => e
            App.logger.warn e.message
            flash[:error] = 'Failed! Please try again later.'
            routing.redirect "/post/#{post_id}"
          end

          # GET /post/{post_id}
          routing.get do
            single_post = FetchPosts.new(App.config).single(post_id, @current_account)
            post = Post.new(single_post, giving_policies: true)
            view :post, locals: { single_post: post }
          end
        end
        # GET /post
        routing.get do
          all_posts = FetchPosts.new(App.config).call
          posts = Posts.new(all_posts)
          view 'all_posts', locals: { all_posts: posts }
        end
      end
    end
  end
end
