# frozen_string_literal: true

require "sharktrack/http_client"
require "active_support/core_ext/string"

module Sharktrack
  # allow calling method like Sharktrack
  module DefineService
    def define_service(service)
      "Sharktrack::#{service.capitalize}".constantize.define_singleton_method("track_by_number") do |number, **options|
        Sharktrack::HTTPClient.build(service.to_s, **options).track_by_number(number)
      end
    end
  end
end
