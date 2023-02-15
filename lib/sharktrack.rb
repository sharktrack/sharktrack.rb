# frozen_string_literal: true

require_relative "sharktrack/version"
require_relative "sharktrack/response"

module Sharktrack
  class Error < StandardError; end
  class UnsupportedReseponseFormatError < StandardError; end
end
