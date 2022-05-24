# frozen_string_literal: true

require_relative 'post'

module Labook
  # Behaviors of the currently logged in account
  class Posts
    attr_reader :all

    def initialize(posts_list)
      @all = posts_list.map do |post|
        Post.new(post)
      end
    end
  end
end
