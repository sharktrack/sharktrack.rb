# frozen_string_literal: true

require "active_support/core_ext/hash/except"
require_relative "concerns/parsable"
require_relative "event"
module Sharktrack
  # Common response
  class Response
    include Concerns::Parsable

    attr_accessor :tracking_number, :ship_to, :estimated_delivery_date, :courier, :events, :origin_body

    def initialize(**params)
      parse_params!(params)
    end

    def inspect
      {
        tracking_number: tracking_number,
        courier: courier,
        estimated_delivery_date: estimated_delivery_date,
        ship_to: ship_to,
        origin_body: origin_body
      }
    end
  end
end
