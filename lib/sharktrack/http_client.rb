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

      case service
      when "fedex"
        client = Sharktrack::Fedex::Client.new(service).configure(options)
        client.validate_configs!
      else
        raise ServiceNotSupport, "#{service.to_s.capitalize} is not supported yet."
      end

      client
    end

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

    def build_response(**params)
      params[:response_format] ||= default_format

      res = Response.new(**params)
    end
  end
end
