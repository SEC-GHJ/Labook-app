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
          lab = FetchLabs.new(App.config).single(lab_id, @current_account)
          single_lab = Lab.new(lab)
          labposts_list = FetchLabs.new(App.config).lab_posts(lab_id, @current_account)
          lab_posts = Posts.new(labposts_list) unless labposts_list.nil?
          view 'lab', locals: { single_lab:, lab_posts:, current_account: @current_account }
        end

        # GET /labs
        routing.get do
          labs = FetchLabs.new(App.config).call(@current_account)
          all_labs = Labs.call(labs)
          view 'home', locals: { all_labs: }
        end

        # GET api/v1/labs/[lab_id]/posts
        routing.get do
          posts = FetchLabs.new(App.config).lab_posts(@current_account)
          lab_posts = Posts.new(posts)
          view 'lab', locals: { lab_posts: }
        end
      end
    end
  end
end
