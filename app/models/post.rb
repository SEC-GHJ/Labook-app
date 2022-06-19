# frozen_string_literal: true

module Labook
  # Behaviors of the currently logged in account
  class Post
    attr_reader :lab_name, :school, :department, :professor,
                :post_id, :poster_id, :lab_score, :professor_attitude, :content, :accept_mail, :vote_sum, :created_at,
                :comments, :policies, :voted_number

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def initialize(post_info, giving_policies: false)
      @lab_id = post_info['include']['lab_info']['attributes']['lab_id']
      @lab_name = post_info['include']['lab_info']['attributes']['lab_name']
      @school = post_info['include']['lab_info']['attributes']['school']
      @department = post_info['include']['lab_info']['attributes']['department']
      @professor = post_info['include']['lab_info']['attributes']['professor']

      @post_id = post_info['attributes']['post_id']
      @poster_id = post_info['attributes']['poster_id']
      @lab_score = post_info['attributes']['lab_score']
      @professor_attitude = post_info['attributes']['professor_attitude']
      @content = post_info['attributes']['content']
      @accept_mail = post_info['attributes']['accept_mail']
      @vote_sum = post_info['attributes']['vote_sum']
      @created_at = post_info['attributes']['created_at'][..-10]

      unless post_info['include']['comments'].nil?
        @comments = post_info['include']['comments'].each_with_index.map do |comment, num|
          if giving_policies
            Comment.new(comment, num, giving_policies: true)
          else
            Comment.new(comment, num)
          end
        end

        @comments.sort_by! do |comment|
          [comment.vote_sum, -comment.num[1..].to_i]
        end.reverse!
      end

      process_policies(post_info['policies']) if giving_policies
      @voted_number = post_info['voted_number'] if giving_policies
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def process_policies(policies)
      @policies = Struct.new(policies)
    end
  end
end
