# frozen_string_literal: true

module Sharktrack
  module Concerns
    # Auto parsing response body to hash attributes
    module Parsable
      attr_reader :origin_body, :response_format

      def parse_params!(**hash)
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
        lacked_keys = %i[origin_body response_format] - hash.keys
        raise ArgumentError, "key #{lacked_keys.join(", ")} are expected" if lacked_keys.any?

        @origin_body = hash[:origin_body]
        @response_format = hash[:response_format]

        hash.except(:origin_body, :response_format)
      end

      def parser
        Parsers.const_get("#{response_format.capitalize}Parser")
      rescue NameError
        raise Sharktrack::UnsupportedReseponseFormatError,
              "#{response_format.capitalize} response is not supported yet."
      end
    end
  end
end
