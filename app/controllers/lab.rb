# frozen_string_literal: true

require 'roda'
require_relative './app'

module Labook
  # Web controller for Labook API
  class App < Roda
    route('lab') do |routing|
      routing.on do
        # GET /labs/{lab_id}
        routing.on String do |lab_id|
          single_lab = FetchLabs.new(App.config).single(lab_id)
          lab = Lab.new(single_lab)
          view 'lab', locals: { single_lab: lab }
        end
        # GET /labs
        routing.get do
          binding pry
          all_labs = FetchLabs.new(App.config).call
          labs = Labs.new(all_labs)
          view 'lab', locals: { all_labs: labs }
        end
      end
    end
  end
end
