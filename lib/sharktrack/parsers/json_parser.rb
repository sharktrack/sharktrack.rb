# frozen_string_literal: true

require "json"

module Sharktrack
  module Parsers
    # JsonParser
    class JsonParser
      attr_reader :body

      def initialize(body)
        @body = body
      end

      def parse!
        return {} if @body.empty?

        JSON.parse(@body)
      end
    end
  end
end
