# frozen_string_literal: true

require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"

module Sharktrack
  module Parsers
    # Basic Parser
    class Parser
      attr_reader :body

      def initialize(body)
        @body = body
      end

      def hash_with_different_acesss
        ActiveSupport::HashWithIndifferentAccess.new(parse!)
      end

      def parse!
        raise NotImplementedError, "Method missing in #{self.class}"
      end
    end
  end
end
