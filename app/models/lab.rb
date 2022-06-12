# frozen_string_literal: true

module Labook
  # Behaviors of the all the labs
  class Lab
    attr_reader :lab_id, :lab_name, :department, :school, :professor

    def initialize(lab_info)
      @lab_id = lab_info['attributes']['lab_id']
      @lab_name = lab_info['attributes']['lab_name']
      @department = lab_info['attributes']['department']
      @school = lab_info['attributes']['school']
      @professor = lab_info['attributes']['professor']
    end
  end
end
