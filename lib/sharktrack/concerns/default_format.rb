# frozen_string_literal: true

require "active_support/concern"

module Sharktrack
  module Concerns
    # set default format
    module DefaultFormat
      def default_response_format(format)
        define_method(:default_format) do
          format
        end
      end
    end
  end
end
