# frozen_string_literal: true

require "active_support/core_ext/hash/except"
require_relative "parsers/json_parser"
module Sharktrack
  # Common response
  class Response
    attr_accessor :tracking_number, :ship_to, :estimated_delivery_date, :courier
    attr_reader :origin_body, :response_format

    def initialize(**hash)
      params = process_parameters!(hash)

      params.each do |key, value|
        send("#{key}=", value) if respond_to?(key)
      end
    end

    def attributes
      parser.new(origin_body).parse!
    end

    private

    def process_parameters!(hash)
      raise ArgumentError, ":origin_body is expected" unless hash[:origin_body]
      raise ArgumentError, ":response_format is expected" unless hash[:response_format]

      @origin_body = hash[:origin_body]
      @response_format = hash[:response_format]

      hash.except(:origin_body, :response_format)
    end

    def parser
      Parsers.const_get("#{response_format.capitalize}Parser")
    rescue NameError
      raise Sharktrack::UnsupportedReseponseFormatError, "#{response_format.capitalize} response is not supported yet."
    end
  end
end
