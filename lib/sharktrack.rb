# frozen_string_literal: true

require_relative "sharktrack/version"
require_relative "sharktrack/response"
require_relative "sharktrack/fedex/client"
require_relative "sharktrack/configurable"
require_relative "sharktrack/define_service"

# Integrate various package tracking services
module Sharktrack
  extend Configurable
  extend DefineService

  class Error < StandardError; end
  class UnsupportedReseponseFormatError < Error; end
  class ServiceNotSupport < Error; end
  class MissingConfigurations < Error; end

  define_service :fedex
end
