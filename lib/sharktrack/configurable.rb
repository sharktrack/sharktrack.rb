# frozen_string_literal: true

module Sharktrack
  # Dynamic configuration
  # SharkTrack.configure do |config|
  #   config.xx_token = "SERCRET"
  # end
  module Configurable
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def setup
      @config = nil
    end

    # Acess SharkTrack.config to get configurations
    class Configuration
      attr_accessor :fedex

      def initialize
        @enable_access_log = true
        @timeout = nil
        @enable_debug = true
      end
    end
  end
end
