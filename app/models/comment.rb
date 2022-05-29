# frozen_string_literal: true

module Labook
  # Behaviors of the currently logged in account
  class Comment
    attr_reader :content, :accept_mail, :vote_sum, :created_at, :num

    def initialize(comment_info, num)
      comment_info = comment_info[0]
      @num = "B#{num + 1}"
      @content = comment_info['attributes']['content']
      @accept_mail = comment_info['attributes']['accept_mail']
      @vote_sum = comment_info['attributes']['vote_sum']
      @created_at = comment_info['attributes']['created_at']
    end
  end
end
