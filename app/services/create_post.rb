# frozen_string_literal: true

require 'http'


module Labook
  # Returns an new created post
  class CreatePost
    class FindLabError < StandardError 
      def message = "Can not find or create Lab";
    end

    def initialize(config, current_account)
      @config = config
      @current_account = current_account
    end

    def call(lab, params)
      message = {
        lab_score: params[:lab_score],
        content: params[:content],
        professor_attitude: params[:professor_attitude],
        vote_sum: 0
      }
      response = HTTP.auth("Bearer #{@current_account.auth_token}")
                     .post("#{@config.API_URL}/labs/#{lab.lab_id}/posts",
                           json: message)
      raise unless response.code == 201

      response.parse['data']
    end
  end
end
