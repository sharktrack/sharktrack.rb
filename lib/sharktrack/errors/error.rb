# frozen_string_literal: true

module Sharktrack
  class Error < StandardError; end
  class UnsupportedReseponseFormatError < Error; end
  class ServiceNotSupport < Error; end
  class MissingConfigurations < Error; end

  # raise when http request return an error code
  class ResponseCodeError < Sharktrack::Error
    attr_reader :response

    def initialize(message, response)
      super(message)

      @response = response
    end
  end
  
  class ResponseContentError < ResponseCodeError; end;
end
