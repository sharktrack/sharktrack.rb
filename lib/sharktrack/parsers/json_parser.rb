# frozen_string_literal: true

require "json"
require_relative "parser"

module Sharktrack
  module Parsers
    # JsonParser
    class JsonParser < Parser
      def parse!
        return {} if @body.empty?

        JSON.parse(@body)
      end
    end
  end
end
