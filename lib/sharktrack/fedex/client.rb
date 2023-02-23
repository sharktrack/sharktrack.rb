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
        raw_response = post("/", request_body(number))

        process_raw_response(raw_response)
      end

      private

      def process_raw_response(raw_response)
        Sharktrack::Response.new(origin_body: raw_response[:origin_body])
      end

      def request_body(number)
        <<~XML
          <soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/'
          xmlns:v16='http://fedex.com/ws/track/v16'>
              <soapenv:Header/>
              <soapenv:Body>
              <v16:TrackRequest>
              <v16:WebAuthenticationDetail>
              <v16:UserCredential>
              <v16:Key>#{credentials["key"]}</v16:Key>
                  <v16:Password>#{credentials["password"]}</v16:Password>
                  </v16:UserCredential>
                  </v16:WebAuthenticationDetail>
                  <v16:ClientDetail>
                  <v16:AccountNumber>#{credentials["account"]}</v16:AccountNumber>
                  <v16:MeterNumber>#{credentials["meter"]}</v16:MeterNumber>
                  </v16:ClientDetail>
                  <v16:TransactionDetail>
                  <v16:CustomerTransactionId>Track By Number_v16</v16:CustomerTransactionId>
                  <v16:Localization>
                  <v16:LanguageCode>#{language.fetch(:language_code)}</v16:LanguageCode>
                  <v16:LocaleCode>#{language.fetch(:locale_code)}</v16:LocaleCode>
                  </v16:Localization>
                  </v16:TransactionDetail>
                  <v16:Version>
                  <v16:ServiceId>trck</v16:ServiceId>
                  <v16:Major>16</v16:Major>
                  <v16:Intermediate>0</v16:Intermediate>
                  <v16:Minor>0</v16:Minor>
                  </v16:Version>
                  <v16:SelectionDetails>
                  <v16:CarrierCode>FDXE</v16:CarrierCode>
                  <v16:PackageIdentifier>
                  <v16:Type>TRACKING_NUMBER_OR_DOORTAG</v16:Type>
                  <v16:Value>#{number}</v16:Value>
                  </v16:PackageIdentifier>
                  <v16:PagingDetail>
                  <v16:NumberOfResultsPerPage>1</v16:NumberOfResultsPerPage>
                  </v16:PagingDetail>
                  </v16:SelectionDetails>
                  <v16:ProcessingOptions>INCLUDE_DETAILED_SCANS</v16:ProcessingOptions>
                  </v16:TrackRequest>
                  </soapenv:Body>
              </soapenv:Envelope>
        XML
      end

      def language
        lang = options[:language] || "en"

        {
          language_code: lang.downcase == "fr" ? "FR" : "EN",
          locale_code: lang.downcase == "fr" ? "CA" : "US"
        }
      end
    end
  end
end
