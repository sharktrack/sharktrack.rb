# frozen_string_literal: true

require_relative "concerns/parsable"

module Sharktrack
  # Track Event
  class Event
    include Concerns::Parsable

    attr_accessor :timestamp, :description, :country, :city, :province

    def initialize(**params)
      parse_params(**params)
    end
  end
end
