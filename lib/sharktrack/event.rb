# frozen_string_literal: true

module Sharktrack
  # Track Event
  class Event
    include Concerns::Parsable

    attr_accessor :timestamp, :description

    def initialize(**params)
      parse_params(**params)
    end
  end
end
