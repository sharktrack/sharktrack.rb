# frozen_string_literal: true

require "active_support/core_ext/hash/except"
require_relative "parsers/json_parser"
require_relative "concerns/parsable"
module Sharktrack
  # Common response
  class Response
    include Concerns::Parsable

    attr_accessor :tracking_number, :ship_to, :estimated_delivery_date, :courier

    def initialize(**params)
      parse_params!(**params)
    end
  end
end
