# frozen_string_literal: true

require "active_support/concern"

module Sharktrack
  module Concerns
    # validatable keys
    module KeyValidatable
      extend ActiveSupport::Concern

      @required_keys = []

      def self.required_keys
        @required_keys
      end

      included do
        def self.validate_keys(*validate_keys, inner: false)
          KeyValidatable.required_keys ||= []
          KeyValidatable.required_keys << if inner
                                            { "#{inner}": validate_keys }
                                          else
                                            validate_keys
                                          end
        end
      end

      # rubocop:disable Metrics/AbcSize
      def validate_configs!
        # Validate
        basic_keys = KeyValidatable.required_keys.select { |key| key unless key.is_a?(Hash) }
        lacked_keys = basic_keys.flatten - options.keys

        raise Sharktrack::MissingConfigurations, "Missing options: #{lacked_keys.join(", ")}" if lacked_keys.any?

        inner_keys = KeyValidatable.required_keys - basic_keys
        inner_keys.each do |hash|
          lacked_keys = hash[hash.keys[0]] - send(hash.keys[0]).keys

          if lacked_keys.any?
            raise Sharktrack::MissingConfigurations,
                  "Missing #{hash.keys[0]}: #{lacked_keys.join(", ")}"
          end
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
