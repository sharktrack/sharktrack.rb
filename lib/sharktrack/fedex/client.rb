# frozen_string_literal: true

require "sharktrack/http_client"

module Sharktrack
  module Fedex
    # Fedex Client
    class Client < Sharktrack::HTTPClient
      default_response_format :xml

      def validate_configs!
        required_keys = %i[key password account meter]

        lacked_keys = required_keys - credentials.keys

        raise Sharktrack::MissingConfigurations, "Missing credential: #{lacked_keys.join(", ")}" if lacked_keys.any?
      end

      def track_by_number(number)
        puts number
        response = <<-XML
          <note>
          <to>Tove</to>
          <from>Jani</from>
          <heading>Reminder</heading>
          <body>Don't forget me this weekend!</body>
          </note>
        XML

        raw_response = build_response(origin_body: response)
        process_raw_response(raw_response)
      end

      private

      def process_raw_response(raw_response)
        attributes = raw_response.attributes
        raw_response.ship_to = attributes["note"]["to"]

        raw_response
      end
    end
  end
end
