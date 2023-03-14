# frozen_string_literal: true

require "active_support/core_ext/hash/except"
module Sharktrack
  module Concerns
    # Auto parsing response body to hash attributes
    module Parsable
      # Asign hash params to instance attributes
      def parse_params!(hash)
        params = process_parameters!(hash)

        params.each do |key, value|
          send("#{key}=", value) if respond_to?(key)
        end
      end

      private

      def process_parameters!(hash)
        lacked_keys = %i[body] - hash.keys
        raise ArgumentError, "key #{lacked_keys.join(", ")} are expected" if lacked_keys.any?

        @origin_body = hash[:body]

        hash.except(:body)
      end
    end
  end
end
