# frozen_string_literal: true

require "sharktrack/http_client"
require "sharktrack/concerns/key_validatable"
require "active_support/core_ext/array"

module Sharktrack
  module Fedex
    # Fedex Client
    class Client < Sharktrack::HTTPClient
      include Concerns::KeyValidatable

      validate_keys :key, :password, :account, :meter, inner: :credentials

      default_response_format :xml

      # @param [string] tracking_number
      def track_by_number(number)
        raw_response = post("/", request_body(number))

        process_raw_response(raw_response)
      end

      private

      # rubocop:disable Metrics/AbcSize
      def process_raw_response(raw_response)
        body = raw_response.dig("Envelope", "Body")
        status = body.dig("TrackReply", "HighestSeverity")
        raise ResponseContentError.new("Fedex return HighestSeverity error", raw_response) if status == "ERROR"

        track_detail = body.dig("TrackReply", "CompletedTrackDetails")
        track_notification = track_detail.fetch("TrackDetails").fetch("Notification")
        if track_notification["Severity"] == "ERROR"
          raise ResponseContentError.new(track_notification["Message"],
                                         raw_response)
        end

        tracking_number = track_detail.dig("TrackDetails", "TrackingNumber")
        ship_to = track_detail.dig("TrackDetails", "DestinationAddress")
        events = Array.wrap(track_detail.dig("TrackDetails", "Events"))
        estimated_delivery_date = track_detail.dig("TrackDetails", "DatesOrTimes").find do |date|
          date["Type"] == "ESTIMATED_DELIVERY"
        end.try(:[], "DateOrTimestamp")

        Sharktrack::Response.new(courier: "fedex",
                                 tracking_number: tracking_number,
                                 ship_to: ship_to,
                                 estimated_delivery_date: estimated_delivery_date,
                                 body: raw_response,
                                 events: events.map { |e| process_raw_event(e) })
      end
      # rubocop:enable Metrics/AbcSize

      def process_raw_event(raw_event)
        timestamp = raw_event["Timestamp"]
        description = raw_event["EventDescription"]
        country = raw_event.dig("Address", "CountryCode")
        province = raw_event.dig("Address", "StateOrProvinceCode")
        residential = raw_event.dig("Address", "Residential")

        Sharktrack::Event.new(timestamp: timestamp,
                              description: description,
                              country: country,
                              province: province,
                              residential: residential.to_s == "true",
                              body: raw_event)
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
              <v16:Key>#{credentials[:key]}</v16:Key>
              <v16:Password>#{credentials[:password]}</v16:Password>
              </v16:UserCredential>
              </v16:WebAuthenticationDetail>
              <v16:ClientDetail>
              <v16:AccountNumber>#{credentials[:account]}</v16:AccountNumber>
              <v16:MeterNumber>#{credentials[:meter]}</v16:MeterNumber>
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
