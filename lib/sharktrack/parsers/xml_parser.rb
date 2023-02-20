# frozen_string_literal: true

require_relative "parser"
require "active_support/core_ext/hash/conversions"

module Sharktrack
  module Parsers
    # XmlParser
    class XmlParser < Parser
      def parse!
        return {} if @body.empty?

        Hash.from_xml(@body.to_s)
      end
    end
  end
end
