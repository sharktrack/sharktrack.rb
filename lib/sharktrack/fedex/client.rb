# frozen_string_literal: true

require "sharktrack/http_client"

module Sharktrack
  module Fedex
    # Fedex Client
    class Client < Sharktrack::HTTPClient
      def validate_configs!
        required_keys = %i[key password account meter]

        lacked_keys = required_keys - credentials.keys

        raise Sharktrack::MissingConfigurations, "Missing credential: #{lacked_keys.join(", ")}" if lacked_keys.any?
      end

      def track_by_number(number)
        ## Dummy method to test
        puts number
      end
    end
  end
end
