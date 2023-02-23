# frozen_string_literal: true

module Sharktrack
  module Concerns
    # Auto parsing response body to hash attributes
    module Parsable
      def parse_params!(hash)
        params = process_parameters!(hash)

        params.each do |key, value|
          send("#{key}=", value) if respond_to?(key)
        end
      end

      private

      def process_parameters!(hash)
        puts hash.keys
        lacked_keys = %i[origin_body] - hash.keys
        raise ArgumentError, "key #{lacked_keys.join(", ")} are expected" if lacked_keys.any?

        @origin_body = hash[:origin_body]

        hash.except(:origin_body)
      end
    end
  end
end
