# frozen_string_literal: true

require 'delegate'

module JSON
  module Patch
    class Document
      class Pointer
        DECODED_CHARACTERS = {
          '~0' => '~',
          '~1' => '/'
        }.freeze

        class Error < Patch::Error; end

        class InvalidArrayIndex < Error
          attr_reader :reference_token

          def initialize(reference_token, message)
            @reference_token = reference_token
            super(message)
          end

          def message
            "can not convert reference `#{reference_token}` to an integer: " \
              "#{super}"
          end
        end

        class ReferenceToken < SimpleDelegator
          def to_int
            return -1 if self == '-'

            unless /^[0-9]+$/ =~ self
              raise InvalidArrayIndex.new(self, 'contains non-digit characters')
            end

            unless self == '0' || start_with?(/[1-9]/)
              raise InvalidArrayIndex.new(self, 'contains leading zeros')
            end

            __getobj__.to_i
          end

          alias to_i to_int
        end

        attr_reader :reference_tokens

        def initialize(raw)
          raise Error, "Invalid pointer: #{raw}" unless %r{^(/[^/]*)*$}.match?(raw)

          escaped_tokens = raw.scan(%r{(?<=/)[^/]*})
          @reference_tokens = escaped_tokens.map { build_token(_1) }
        end

        private

        def build_token(escaped)
          decoded = decode_escaped_characters(escaped)

          ReferenceToken.new(decoded)
        end

        def decode_escaped_characters(token)
          token.gsub(/~([01])/) { DECODED_CHARACTERS[_1] }
        end
      end
    end
  end
end
