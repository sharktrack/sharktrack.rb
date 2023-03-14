# frozen_string_literal: true

require_relative "sharktrack/version"
require_relative "sharktrack/response"
require_relative "sharktrack/fedex/client"
require_relative "sharktrack/configurable"
require_relative "sharktrack/define_service"
require_relative "sharktrack/errors/error"

# Integrate various package tracking services
module Sharktrack
  extend Configurable
  extend DefineService

  define_service :fedex
end
