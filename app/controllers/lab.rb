# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('labs') do |routing|
      routing.on do
        # GET /labs/{lab_id}
        # GET /labs/[lab_id]/posts
        routing.on String do |lab_id|
          @lab = FetchLabs.new(App.config).single(lab_id, @current_account)
          @single_lab = Lab.new(@lab)

          # GET /labs/[lab_id]/new_post
          routing.on 'new_post' do
            # check whether the user is logged in
            unless @current_account.logged_in?
              flash[:error] = 'Please log in or register an account to create post!!'
              routing.redirect '/auth/login'
            end

            routing.get do
              view 'new_post', locals: { single_lab: @single_lab }
            end
            
            routing.post do
              new_post = Form::Post.new.call(routing.params)

              if new_post.failure?
                flash[:error] = Form.validation_errors(new_post)
                raise
              end

              post = CreatePost.new(App.config, @current_account)
                               .call(@single_lab, new_post.values)
              post = Post.new(post)
              
              flash[:notice] = "Successfully post a post !!! Thank you for sharing your experience."
              routing.redirect "/post/#{post.post_id}"
            rescue StandardError => e
              flash[:error] = 'Input error, can not upload a new post'
              routing.redirect '/'
            end
          end

          # GET /labs/{lab_id}
          routing.is do
            labposts_list = FetchLabs.new(App.config).lab_posts(lab_id, @current_account)
            lab_posts = Posts.new(labposts_list) unless labposts_list.nil?
            view 'lab', locals: { single_lab: @single_lab,
                                  lab_posts:,
                                  current_account: @current_account }
          end
        end

        # GET /labs
        routing.get do
          labs = FetchLabs.new(App.config).call(@current_account)
          all_labs = Labs.call(labs)
          view 'home', locals: { all_labs: }
        end
      end
    end
  end
end
