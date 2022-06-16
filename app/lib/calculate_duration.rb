# frozen_string_literal: true

require 'time_difference'

# Calculate the last seen duration
class CalculateDuration
  def self.format(unit, value)
    "#{value} #{unit.to_s.singularize.pluralize(value)}"
  end

  def self.duration(time)
    return nil if time.nil?
    created_at = Time.parse(time)
    duration = TimeDifference.between(created_at, Time.now).in_general

    # return value once value is not 0
    all_zero_flag = true
    out_put_string = "now"
    duration.each do |unit, value|
      if value != 0
        all_zero_flag = false
        out_put_string = format(unit, value) 
        break
      end
    end

    out_put_string
  end
end
