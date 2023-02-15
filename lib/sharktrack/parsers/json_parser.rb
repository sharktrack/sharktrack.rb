# frozen_string_literal: true

module Sharktrack
  module Parsers
    # JsonParser
    class JsonParser
      attr_reader :body

      def initialize(body)
        @body = body
      end

      def parse!
        # TODO: parse raw response to hash
        {}
      end
    end
  end
end
