# frozen_string_literal: true

require_relative "fedex/client"
require_relative "concerns/default_format"
require "typhoeus"
require "sharktrack/response"

require_relative "parsers/json_parser"
require_relative "parsers/xml_parser"

module Sharktrack
  # Wrap typhoeus for http request
  class HTTPClient
    extend Concerns::DefaultFormat

    attr_reader :client, :service, :options, :default_format

    class << self
      attr_reader :default_format
    end

    def self.build(service, **options)
      @service = service

      client = case service
               when "fedex"
                 Sharktrack::Fedex::Client.new(service).configure(options)
               else
                 raise ServiceNotSupport, "#{service.to_s.capitalize} is not supported yet."
               end

      client.validate_configs!
      client
    end

    # Implmentation of track_by_number features for differenct clients
    # Expect to return Sharktrack::Response as result
    def track_by_number(*args)
      raise NotImplementedError, "Method missing in #{self.class}"
    end

    def configure(options = {})
      process_credentials!(options[:credentials] || {})

      @options = options.merge(configurations)

      self
    end

    def validate_configs!
      # In each subclass, implment configuration validation
    end

    def base_uri
      configurations[:base_uri]
    end

    def post(uri, body)
      request = Typhoeus::Request.new("#{base_uri}#{uri}",
                                      method: :post,
                                      body: body,
                                      header: default_headers.merge(headers))

      request.run
      body = request.response.body.to_s
      # create a hash object, and provide the original body
      raw = parser.new(body).hash_with_different_acesss
      raw[:origin_body] = body
      raw
    end

    def headers
      {}
    end

    private

    attr_reader :credentials

    def configurations
      Sharktrack.config.send(service) || {}
    end

    def process_credentials!(credentials)
      @credentials = configurations[:credentials] || {}
      @credentials = @credentials.merge(credentials)
    end

    def initialize(service)
      @service = service
      @client = Typhoeus
    end

    def default_headers
      {
        "User-Agent" => "Sharktrack/#{Sharktrack::VERSION} (Language=Ruby)",
        "Content-Type" => "application/json"
      }
    end

    def parser
      Parsers.const_get("#{default_format.capitalize}Parser")
    rescue NameError
      raise Sharktrack::UnsupportedReseponseFormatError,
            "#{default_format.capitalize} response is not supported yet."
    end
  end
end
