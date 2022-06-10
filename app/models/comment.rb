# frozen_string_literal: true

module Labook
  # Behaviors of the currently logged in account
  class Comment
    attr_reader :content, :commenter_id, :accept_mail, :vote_sum, :created_at, :num, :policies, :voted_number

    def initialize(comment_info, num, giving_policies=false)
      comment_info = comment_info[0]
      @num = "B#{num + 1}"
      @content = comment_info['attributes']['content']
      @commenter_id = comment_info['attributes']['commenter_id']
      @accept_mail = comment_info['attributes']['accept_mail']
      @vote_sum = comment_info['attributes']['vote_sum']
      @created_at = comment_info['attributes']['created_at']

      process_policies(comment_info['policies']) if giving_policies
      @voted_number = comment_info['voted_number'] if giving_policies
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end
  end
end
