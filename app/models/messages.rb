# frozen_string_literal: true

require_relative 'message'
require 'time_difference'

module Labook
  # Behaviors of the all the chatrooms
  class Messages
    attr_reader :all, :last_seen

    def duration(time)
      created_at = Time.parse(time)
      duration = TimeDifference.between(created_at, Time.now).in_general

      duration.each do |unit, value|
        return "#{value} #{unit.to_s.singularize.pluralize(value)}" if value != 0
      end
    end

    def initialize(messages_list)
      @all = messages_list.map do |message|
        Message.new(message)
      end

      @last_seen = all.last.nil? ? nil : duration(all.last.created_at)
    end
  end
end
