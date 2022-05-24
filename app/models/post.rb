# frozen_string_literal: true

module Labook
  # Behaviors of the currently logged in account
  class Post
    attr_reader :post_id, :lab_name, :professor_attitude, :content, :accept_mail, :vote_sum

    def initialize(post_info)
      @post_id = post_info['attributes']['lab_score']
      @lab_name = post_info['attributes']['lab_name']
      @professor_attitude = post_info['attributes']['professor_attitude']
      @content = post_info['attributes']['content']
      @accept_mail = post_info['attributes']['accept_mail']
      @vote_sum = post_info['attributes']['vote_sum']
    end
  end
end
